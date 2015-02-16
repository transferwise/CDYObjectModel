//
//  AuthenticationHelper.m
//  Transfer
//
//  Created by Juhan Hion on 06.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AuthenticationHelper.h"
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
#import "GoogleAnalytics.h"
#import "Credentials.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "PendingPayment.h"
#import "TransferwiseClient.h"
#import "AppDelegate.h"
#import "SignUpViewController.h"

@interface AuthenticationHelper ()

@property (strong, nonatomic) TransferwiseOperation *executedOperation;

@end

@implementation AuthenticationHelper

- (void)validateInputAndPerformLoginWithEmail:(NSString *)email
									 password:(NSString *)password
                           keepPendingPayment:(BOOL)keepPendingPayment
					 navigationControllerView:(UIView *)navigationControllerView
								  objectModel:(ObjectModel *)objectModel
								 successBlock:(TRWActionBlock)successBlock
					waitForDetailsCompletions:(BOOL)waitForDetailsCompletion
{
    [self validateInputAndPerformLoginWithEmail:email password:password keepPendingPayment:keepPendingPayment navigationControllerView:navigationControllerView objectModel:objectModel successBlock:successBlock errorBlock:^(NSError * error) {
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
                           keepPendingPayment:(BOOL)keepPendingPayment
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
																	password:password keepPendingPayment:keepPendingPayment];
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

- (NSString *)validateEmail:(NSString *)email
				   password:(NSString *)password
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

+ (void)proceedFromSuccessfulLoginFromViewController:(UIViewController*)controller
										 objectModel:(ObjectModel*)objectModel
{
    //This method relies on the root view controller of the window being a ConnectionAwareViewController
    
    //If registration upfront is used, these flags won't be set by the intro screen. Set them after logging in.
    [objectModel markIntroShown];
    [objectModel markExistingUserIntroShown];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIWindow* window = appDelegate.window;
    

    if([[objectModel allPayments] count] <= 0)
    {
        //Use smoke and mirrors to sneak in a MainViewController underneath a modally presented new payment viewcontroller
        
        NewPaymentViewController *paymentView = [[NewPaymentViewController alloc] init];
        [paymentView setObjectModel:objectModel];
		
        if(controller.presentingViewController)
        {
            ConnectionAwareViewController* root = (ConnectionAwareViewController*)[controller.navigationController?:controller parentViewController];
            [root replaceWrappedViewControllerWithController:[[UINavigationController alloc] initWithRootViewController:paymentView] withAnimationStyle:ConnectionModalAnimation];
        }
        else
        {
            ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:controller.navigationController?:controller];
            window.rootViewController = root;
            
            ConnectionAwareViewController *wrapper =  [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:paymentView navBarHidden:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [root presentViewController:wrapper animated:YES completion:^{
                    MainViewController *mainController = [[MainViewController alloc] init];
                    [mainController setObjectModel:objectModel];
                    [root replaceWrappedViewControllerWithController:mainController];
                }];
            });
        }
    }
    else
    {
     
        if(controller.presentingViewController)
        {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            ConnectionAwareViewController* root = (ConnectionAwareViewController*) window.rootViewController;
            MainViewController *mainController = [[MainViewController alloc] init];
            [mainController setObjectModel:objectModel];
            [root replaceWrappedViewControllerWithController:mainController];
        }
    }
}

+ (void)logOutWithObjectModel:(ObjectModel *)objectModel tokenNeedsClearing:(BOOL)clearToken completionBlock:(void (^)(void))completionBlock;
{
    if([Credentials userLoggedIn])
    {
        [objectModel performBlock:^{
            [objectModel deleteObject:objectModel.currentUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([Credentials userLoggedIn])
                {
                    [PendingPayment removePossibleImages];
                    if(clearToken)
                    {
                        [[TransferwiseClient sharedClient] clearCredentials];
                    }
                    [Credentials clearCredentials];
                    [[GoogleAnalytics sharedInstance] markLoggedIn];
                    [TransferwiseClient clearCookies];
                    if(completionBlock)
                    {
                        completionBlock();
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:TRWLoggedOutNotification object:nil];
                }
            });
        }];
    }
	
}

@end
