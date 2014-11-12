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

@interface ReferralsCoordinator ()

@property (nonatomic, strong) TransferwiseOperation* currentOperation;

@end

@implementation ReferralsCoordinator

+ (ReferralsCoordinator *)sharedInstance
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] initSingleton];
	});
}

- (id)initSingleton
{
	self = [super init];
	if (self)
	{
		
	}
	
	return self;
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
	InviteViewController *inviteController = [[InviteViewController alloc] init];
	inviteController.referralLinks = referralLinks;
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
			
			[referralLinksOperation setResultHandler:^(NSError *error, NSArray *referralLinks) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[hud hide];
					
					if (!error && referralLinks)
					{
						[self showInviteController:referralLinks weakCoordinator:weakCoordinator weakController:weakController];
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

@end
