//
//  ReferralsCoordinator.m
//  Transfer
//
//  Created by Juhan Hion on 27.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ReferralsCoordinator.h"
#import "Constants.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "ReferralLinksOperation.h"
#import "InviteViewController.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+ReferralLinks.h"
#import "User.h"
#import "ReferralListOperation.h"

#define defaultRewardAmount 50
#define defaultRewardCurrency @"GBP"
#define amountUpdateDeltaT -86400

@interface ReferralsCoordinator ()

@property (nonatomic, strong) TransferwiseOperation* currentOperation;
@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;
@property (nonatomic, strong) NSDate *lastRewardUpdateDate;
@property (nonatomic, strong) NSMutableArray* rewardCallbacks;

@end

@implementation ReferralsCoordinator

+ (ReferralsCoordinator *)sharedInstanceWithObjectModel:(ObjectModel*)objectModel
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		ReferralsCoordinator* coordinator = [[self alloc] initSingleton];
        coordinator.objectModel = objectModel;
        return coordinator;
        
	});
}

- (id)initSingleton
{
	self = [super init];
	if (self)
	{
        NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setCurrencyCode:defaultRewardCurrency];
        [currencyFormatter setMaximumFractionDigits:0];
        [currencyFormatter setMinimumFractionDigits:0];
        self.currencyFormatter = currencyFormatter;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLastRewardUpdatedDate) name:TRWLoggedOutNotification object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
										   NSStringFromClass([self class]),
										   NSStringFromSelector(@selector(sharedClient))]
								 userInfo:nil];
	return nil;
}

- (void)showInviteController:(NSArray *)referralLinks
			 weakCoordinator:(ReferralsCoordinator *)coordinator
			  weakController:(UIViewController *)controller
{
	InviteViewController *inviteController = [[InviteViewController alloc] initWithReferralLinks:referralLinks
																					rewardAmount:[self rewardAmountString]];
	inviteController.objectModel = coordinator.objectModel;
	[inviteController presentOnViewController:controller.view.window.rootViewController];
}

- (void)presentOnController:(UIViewController *)controller
{
	User *user = self.objectModel.currentUser;
	
	if (user)
	{
		NSArray *referralLinks = [self.objectModel referralLinks];
		
		if (referralLinks && [referralLinks count] > 0)
		{
			[self showInviteController:referralLinks
					   weakCoordinator:self
						weakController:controller];
		}		
		else
		{
			TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:controller.navigationController.view];
			[hud setMessage:NSLocalizedString(@"invite.link.querying", nil)];
			ReferralLinksOperation *referralLinksOperation = [ReferralLinksOperation operation];
			[referralLinksOperation setObjectModel:self.objectModel];
			self.currentOperation = referralLinksOperation;
			
			__weak UIViewController* weakController = controller;
			__weak ReferralsCoordinator* weakCoordinator = self;
			
			[referralLinksOperation setResultHandler:^(NSError *error) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[hud hide];
					
                    weakCoordinator.currentOperation = nil;
					NSArray *referralLinks = [weakCoordinator.objectModel referralLinks];
					
					if (!error && referralLinks)
					{
						[weakCoordinator showInviteController:referralLinks weakCoordinator:weakCoordinator weakController:weakController];
						return;
					}
					
					TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.link.error.title", nil)
																	   message:NSLocalizedString(@"invite.link.error.message", nil)];
					[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
					[alertView show];
				});
			}];
			
			[referralLinksOperation execute];
		}
	}
}

-(void)requestRewardStatus:(void(^)(NSError*))completionBlock
{
    if(!self.lastRewardUpdateDate || [self.lastRewardUpdateDate timeIntervalSinceNow] < amountUpdateDeltaT)
    {
        if(completionBlock)
        {
            if(!self.rewardCallbacks)
            {
                self.rewardCallbacks = [NSMutableArray array];
            }
            [self.rewardCallbacks addObject:completionBlock];
        }
        
        //This request has lower priority than the links operation. Only excecute if no other request is running.
        if(!self.currentOperation)
        {
            ReferralListOperation *referralListOperation = [ReferralListOperation operation];
            self.currentOperation = referralListOperation;
            [referralListOperation setObjectModel:self.objectModel];
            self.currentOperation = referralListOperation;
            __weak typeof(self) weakSelf = self;
            [referralListOperation setResultHandler:^(NSError* error){
                weakSelf.currentOperation = nil;
                if(!error)
                {
                    weakSelf.lastRewardUpdateDate = [NSDate date];
                }
                
                [weakSelf completeOutstandingCompletionBlocksWithError:error];
            }];
            
            [referralListOperation execute];
        }
        else if (![self.currentOperation isKindOfClass:[ReferralListOperation class]])
        {
            [self completeOutstandingCompletionBlocksWithError:nil];
        }
        
    }
    else
    {
        if(completionBlock)
        {
            completionBlock(nil);
        }
    }

}

-(void)completeOutstandingCompletionBlocksWithError:(NSError*)error
{
    for(void(^completionblock)(NSError*) in self.rewardCallbacks)
    {
        completionblock(error);
    }
    self.rewardCallbacks = nil;
}

-(NSString*)rewardAmountString
{
    [self requestRewardStatus:nil];
    
    NSNumber *rewardNumber =@(defaultRewardAmount);
    
    if([[self.objectModel currentUser].invitationReward intValue] > 0)
    {
        rewardNumber = [self.objectModel currentUser].invitationReward;
    }
    
    if ([self.objectModel currentUser].invitationRewardCurrency)
    {
        self.currencyFormatter.currencyCode = [self.objectModel currentUser].invitationRewardCurrency;
    }
    
    return [self.currencyFormatter stringFromNumber:rewardNumber];
}

- (void)resetLastRewardUpdatedDate
{
	self.lastRewardUpdateDate = nil;
}

@end
