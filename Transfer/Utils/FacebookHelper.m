//
//  FacebookHelper.m
//  Transfer
//
//  Created by Juhan Hion on 22.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "FacebookHelper.h"
#import <FBSDKLoginKit.h>
#import <FBSDKAccessToken.h>
#import <FBSDKGraphRequest.h>
#import "GoogleAnalytics.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "CustomInfoViewController.h"
#import "AskEmailViewController.h"

@implementation FacebookHelper

- (void)performFacebookLoginWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
								 cancelBlock:(TRWActionBlock)cancelBlock
{
	
	//flag up that we have used FB
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:@(TRWAuthenticationFacebook)
			   forKey:TRWAuthenticationTypeUsedKey];
	
	if ([FBSDKAccessToken currentAccessToken])
	{
		//if we have an existing account, try to use that
		[self handleAccessTokenWithSuccessBlock:successBlock
									 isExisting:YES];
	}
	else
	{
		//do standard auth
		[self doFacebookLoginWithSuccessBlock:successBlock
								  cancelBlock:cancelBlock
								   isExisting:NO];
	}
}

- (void)doFacebookLoginWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
							cancelBlock:(TRWActionBlock)cancelBlock
							 isExisting:(BOOL)isExisting
{
	FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
	[manager logInWithReadPermissions:@[FacebookOAuthEmailScope, FacebookOAuthProfileScope]
							  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
								  //no need to show hud because we are leaving the app
								  if (error)
								  {
									  //Something went pear shaped
									  //Track the error
									  [[GoogleAnalytics sharedInstance] sendAlertEvent:GAFBLoginError
																			 withLabel:[NSString stringWithFormat:@"%lu", (long)error.code]];
									  //Throw up an alert to wherever we are
									  [self showErrorWithMessage:nil];
								  }
								  else if (result.isCancelled)
								  {
									  cancelBlock();
								  }
								  else
								  {
									  [self handleAccessTokenWithSuccessBlock:successBlock
																   isExisting:isExisting];
								  }
							  }];
}

//There is a [FBSDKAccessToken currentAccessToken].
//Try getting email, one way or the other and succeed or fail
- (void)handleAccessTokenWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
							   isExisting:(BOOL)isExisting
{
	if ([FBSDKAccessToken currentAccessToken])
	{
		successBlock([FBSDKAccessToken currentAccessToken].tokenString, isExisting);
	}
	else
	{
		//Tried as we might nothing came of it
		[[GoogleAnalytics sharedInstance] sendAlertEvent:GAFBLoginError
											   withLabel:nil];
		
		[self showErrorWithMessage:nil];
	}
}

- (void)getUserEmailWithResultBlock:(void(^)(NSString * email))resultBlock
			   navigationController:(UINavigationController *)navigationController
{
	//show AskEmailViewController
	AskEmailViewController *askEmailController = [[AskEmailViewController alloc] initWithReturnBlock:^(NSString *email) {
		resultBlock(email);
	}];
	
	[navigationController pushViewController:askEmailController
									animated:YES];

}

- (void)showErrorWithMessage:(NSString *)message
{
	TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil)
													   message:message];
	[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
	[alertView show];
}

- (void)logOut
{
	[[[FBSDKLoginManager alloc] init] logOut];
}

@end
