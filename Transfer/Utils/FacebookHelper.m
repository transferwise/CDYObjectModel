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
#import "AskEmailViewController.h"
#import "GoogleAnalytics.h"
#import "TRWAlertView.h"

@implementation FacebookHelper

- (void)performFacebookLoginWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
								 cancelBlock:(TRWActionBlock)cancelBlock
						navigationController:(UINavigationController *)navigationController
{
	
	//flag up that we have used FB
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES
			   forKey:TRWFacebookLoginUsedKey];
	
	if ([FBSDKAccessToken currentAccessToken])
	{
		//if we have an existing account, try to use that
		[self handleAccessTokenWithSuccessBlock:successBlock
									 isExisting:YES
						   navigationController:navigationController];
	}
	else
	{
		//do standard auth
		[self doFacebookLoginWithSuccessBlock:successBlock
								  cancelBlock:cancelBlock
								   isExisting:NO
						 navigationController:navigationController];
	}
}

- (void)doFacebookLoginWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
							cancelBlock:(TRWActionBlock)cancelBlock
							 isExisting:(BOOL)isExisting
				   navigationController:(UINavigationController *)navigationController
{
	FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
	[manager logInWithReadPermissions:@[FacebookOAuthEmailScope, FacebookOAuthProfileScope]
							  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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
																   isExisting:isExisting
														 navigationController:navigationController];
								  }
							  }];
}

//There is a [FBSDKAccessToken currentAccessToken].
//Try getting email, one way or the other and succeed or fail
- (void)handleAccessTokenWithSuccessBlock:(FacebookLoginSuccessBlock)successBlock
							   isExisting:(BOOL)isExisting
					 navigationController:(UINavigationController *)navigationController
{
	if ([FBSDKAccessToken currentAccessToken])
	{
		//might be necessary to check for a permission here first
		NSString *email = [self getUserEmail];
		
		if (!email)
		{
			__weak typeof(self) weakSelf = self;
			//no access to email or it is missing
			//show AskEmailViewController
			AskEmailViewController *askEmailController = [[AskEmailViewController alloc] initWithReturnBlock:^(NSString *email) {
				[weakSelf handleEmail:email
						 successBlock:successBlock
						   isExisting:isExisting];
			}];
			
			[navigationController pushViewController:askEmailController
											animated:YES];
		}
		else
		{
			[self handleEmail:email
				 successBlock:successBlock
				   isExisting:isExisting];
		}
		
	}
	else
	{
		//Tried as we might nothing came of it
		[[GoogleAnalytics sharedInstance] sendAlertEvent:GAFBLoginError
											   withLabel:nil];
		
		[self showErrorWithMessage:nil];
	}
}

- (NSString *)getUserEmail
{
	//try to get email out of FB
	return nil;
}

- (void)handleEmail:(NSString *)email
	   successBlock:(FacebookLoginSuccessBlock)successBlock
		 isExisting:(BOOL)isExisting
{
	if (email)
	{
		//We are out of the woods!
		successBlock([FBSDKAccessToken currentAccessToken].tokenString, email, isExisting);
	}
	else
	{
		//I am a failure :(
		[[GoogleAnalytics sharedInstance] sendAlertEvent:GAFBLoginNoEmail
											   withLabel:nil];
		
		[self showErrorWithMessage:nil];
	}
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
