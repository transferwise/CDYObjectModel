//
//  LoginHelper.m
//  Transfer
//
//  Created by Juhan Hion on 06.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "LoginHelper.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "UIApplication+Keyboard.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "LoginOperation.h"
#import "NSError+TRWErrors.h"
#import "GoogleAnalytics.h"
#import "MainViewController.h"
#import "ConnectionAwareViewController.h"
#import "ObjectModel+Settings.h"
#import "ObjectModel+Payments.h"
#import "NewPaymentViewController.h"
#import "ConnectionAwareViewController.h"

@interface LoginHelper ()

@property (strong, nonatomic) TransferwiseOperation *executedOperation;

@end

@implementation LoginHelper

- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
									 password:(NSString *)password
					 navigationControllerView:(UIView *)navigationControllerView
								  objectModel:(ObjectModel *)objectModel
								 successBlock:(TRWActionBlock)successBlock
					waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
{
    [self validateInputAndPerformLoginWithEmail:email password:password navigationControllerView:navigationControllerView objectModel:objectModel successBlock:successBlock errorBlock:^(NSError * error) {
        TRWAlertView *alertView;
        if ([error isTransferwiseError])
        {
            NSString *message = [error localizedTransferwiseMessage];
            [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginIncorrectCredentials" withLabel:message];
            alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:message];
        }
        else
        {
            alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil)
                                                 message:NSLocalizedString(@"login.error.generic.message", nil)];
            [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginIncorrectCredentials" withLabel:error.localizedDescription];
        }
        
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        
        [alertView show];

        
    } waitForDetailsCompletions:waitForDetailsCompletion];
}
    
- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
                                     password:(NSString *)password
                     navigationControllerView:(UIView *)navigationControllerView
                                  objectModel:(ObjectModel *)objectModel
                                 successBlock:(TRWActionBlock)successBlock
                                   errorBlock:(void(^)(NSError* error))errorBlock
                    waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
{
	[UIApplication dismissKeyboard];
	
    NSString *issues = [self validateEmail:email password:password];
	
    if ([issues length] > 0)
	{
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
	
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:navigationControllerView];
    [hud setMessage:NSLocalizedString(@"login.controller.logging.in.message", nil)];
	
    LoginOperation *loginOperation = [LoginOperation loginOperationWithEmail:email
																	password:password];
	self.executedOperation = loginOperation;
    [loginOperation setObjectModel:objectModel];
	[loginOperation setWaitForDetailsCompletion:waitForDetailsCompletion];
	
    [loginOperation setResponseHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
			
            if (!error)
			{
                successBlock();
                return;
            }
			
            errorBlock(error);
        });
    }];
	
    [loginOperation execute];
}

- (NSString *)validateEmail:(NSString *)email password:(NSString *)password
{
    NSMutableString *issues = [NSMutableString string];
	
    if (![email hasValue])
	{
        [issues appendIssue:NSLocalizedString(@"login.validation.email.missing", nil)];
    }
	else if ([email hasValue] && ![email isValidEmail])
	{
        [issues appendIssue:NSLocalizedString(@"login.validation.email.not.valid", nil)];
    }
	
    if (![password hasValue])
	{
        [issues appendIssue:NSLocalizedString(@"login.validation.password.missing", nil)];
    }
	
    return [NSString stringWithString:issues];
}

+(void)proceedFromSuccessfulLoginFromViewController:(UIViewController*)controller objectModel:(ObjectModel*)objectModel
{
    //If registration upfront is used, these flags won't be set by the intro screen. Set them after logging in.
    [objectModel markIntroShown];
    [objectModel markExistingUserIntroShown];
    
    if([[objectModel allPayments] count] <= 0)
    {
        //Use smoke and mirrors to sneak in a MainViewController underneath a modally presented new payment viewcontroller
        
        ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:controller.navigationController?:controller];
        controller.view.window.rootViewController = root;
        
        NewPaymentViewController *paymentView = [[NewPaymentViewController alloc] init];
        [paymentView setObjectModel:objectModel];
        ConnectionAwareViewController *wrapper =  [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:paymentView navBarHidden:YES];
        [root presentViewController:wrapper animated:NO completion:^{
            MainViewController *mainController = [[MainViewController alloc] init];
            [mainController setObjectModel:objectModel];
            [root replaceWrappedViewControllerWithController:mainController];
        }];
        [[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];
    }
    else
    {
    
        MainViewController *mainController = [[MainViewController alloc] init];
        [mainController setObjectModel:objectModel];
        ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:mainController];
        controller.view.window.rootViewController = root;
    }
}

@end
