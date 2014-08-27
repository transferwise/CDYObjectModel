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

- (void)presentOnController:(UIViewController *)controller
{
	TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:controller.navigationController.view];
	[hud setMessage:NSLocalizedString(@"invite.link.querying", nil)];
	ReferralLinkOperation *referralLinkOperation = [ReferralLinkOperation operation];
	self.currentOperation = referralLinkOperation;
	
	__weak UIViewController* weakController = controller;
	
	[referralLinkOperation setResultHandler:^(NSError *error, NSString *referralLink) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[hud hide];
			
			if (!error && referralLink)
			{
				InviteViewController *inviteController = [[InviteViewController alloc] init];
				inviteController.inviteUrl = referralLink;
				inviteController.objectModel = self.objectModel;
				[inviteController presentOnViewController:weakController.view.window.rootViewController];
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

@end
