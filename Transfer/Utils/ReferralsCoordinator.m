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
#import "ReferralLinkOperation.h"
#import "InviteViewController.h"
#import "ObjectModel+Users.h"
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

- (void)showInviteController:(NSString *)referralLink
			 weakCoordinator:(ReferralsCoordinator *)coordinator
			  weakController:(UIViewController *)controller
{
	InviteViewController *inviteController = [[InviteViewController alloc] init];
	inviteController.inviteUrl = referralLink;
	inviteController.objectModel = coordinator.objectModel;
	[inviteController presentOnViewController:controller.view.window.rootViewController];
}

- (void)presentOnController:(UIViewController *)controller
{
	User *user = self.objectModel.currentUser;
	
	if (user && user.inviteUrl && [user.inviteUrl rangeOfString:@"/r/"].location == NSNotFound)
	{
		[self showInviteController:user.inviteUrl
				   weakCoordinator:self
					weakController:controller];
	}
	else
	{
		TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:controller.navigationController.view];
		[hud setMessage:NSLocalizedString(@"invite.link.querying", nil)];
		ReferralLinkOperation *referralLinkOperation = [ReferralLinkOperation operation];
		[referralLinkOperation setObjectModel:self.objectModel];
		self.currentOperation = referralLinkOperation;
		
		__weak UIViewController* weakController = controller;
		__weak ReferralsCoordinator* weakCoordinator = self;
		
		[referralLinkOperation setResultHandler:^(NSError *error, NSString *referralLink) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[hud hide];
				
				if (!error && referralLink)
				{
					[self showInviteController:referralLink weakCoordinator:weakCoordinator weakController:weakController];
					return;
				}
				
				TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"invite.link.error.title", nil)
																   message:NSLocalizedString(@"invite.link.error.message", nil)];
				[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
				[alertView show];
			});
		}];
		
		[referralLinkOperation execute];
	}
}

@end
