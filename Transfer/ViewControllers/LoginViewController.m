//
//  LoginViewController.m
//  Transfer
//
//  Created by Juhan Hion on 09.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "LoginViewController.h"
#import "GoogleAnalytics.h"
#import "TransferBackButtonItem.h"
#import "FloatingLabelTextField.h"
#import "GreenButton.h"
#import "OpenIDViewController.h"
#import "UIFont+MOMStyle.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "GoogleButton.h"
#import "YahooButton.h"
#import "UIColor+MOMStyle.h"
#import "NavigationBarCustomiser.h"
#import "AuthenticationHelper.h"
#import "TouchIDHelper.h"
#import "TouchIdPromptViewController.h"
#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"
#import "NetworkErrorCodes.h"
#import "TransferwiseOperation.h"
#import "MainViewController.h"
#import "ConnectionAwareViewController.h"
#import "UITextField+CaretPosition.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

IB_DESIGNABLE

@interface LoginViewController () <UITextFieldDelegate, TouchIdPromptViewControllerDelegate>

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet GreenButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (strong, nonatomic) IBOutlet GoogleButton *googleLoginButton;
@property (strong, nonatomic) IBOutlet YahooButton *yahooLoginButton;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) AuthenticationHelper *loginHelper;
@property (weak, nonatomic) IBOutlet UIButton *touchIdButton;

@property (nonatomic, strong) IBInspectable NSString* xibNameForResetPassword;

@end

@implementation LoginViewController

#pragma mark - Init
- (id)init
{
    self = [super init];
    if (self)
	{
        [self commonSetup];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self commonSetup];
    }
    return self;
}

-(void)commonSetup
{
    _loginHelper = [[AuthenticationHelper alloc] init];
	[self initGPlus];
}

#pragma mark - View Life-cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if(!self.navigationItem.leftBarButtonItem)
    {
        [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController
																									   isBlue:YES]];
    }
	
	[self.emailTextField configureWithTitle:NSLocalizedString(@"login.email.field.title", nil) value:@""];
	self.emailTextField.delegate = self;
	[self.emailTextField setReturnKeyType:UIReturnKeyNext];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
	
	[self.passwordTextField configureWithTitle:NSLocalizedString(@"login.password.field.title", nil) value:@""];
	self.passwordTextField.delegate = self;
	[self.passwordTextField setReturnKeyType:UIReturnKeyDone];
	
	[self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];
	
	[self.forgotPasswordLabel setText:NSLocalizedString(@"login.controller.forgot.password.link", nil)];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordTapped)];
    [self.forgotPasswordLabel addGestureRecognizer:tapGestureRecognizer];
	
	[self.googleLoginButton setTitle:NSLocalizedString([@"button.title.log.in.google" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	[self.yahooLoginButton setTitle:NSLocalizedString([@"button.title.log.in.yahoo" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	
	[self.orLabel setText:NSLocalizedString([@"login.controller.or" deviceSpecificLocalization], nil)];
    self.touchIdButton.hidden = ![TouchIDHelper isTouchIdSlotTaken];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [NavigationBarCustomiser setWhite];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:NSLocalizedString(@"login.controller.title", nil)];
	
    [[GoogleAnalytics sharedInstance] sendScreen:@"Login"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[NavigationBarCustomiser setDefault];
	[super viewWillDisappear:animated];
}

#pragma mark - Google Plus
- (void)initGPlus
{
	GPPSignIn *signIn = [GPPSignIn sharedInstance];
	signIn.shouldFetchGooglePlusUser = NO;
	signIn.shouldFetchGoogleUserEmail = YES;
	signIn.clientID = GoogleOAuthClientId;
	signIn.scopes = @[ @"https://www.googleapis.com/auth/plus.profile.emails.read" ];
	signIn.delegate = self;
	signIn.attemptSSO = YES;
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
				   error:(NSError *)error
{
	if (error)
	{
		//sign out if error happens so user can try another account.
		[[GPPSignIn sharedInstance] signOut];
		
		NSString *message = nil;
		//400 token has been revoked
		//401 means that the token is probably expired
		if (error.code == 400 || error.code == 401)
		{
			message = NSLocalizedString(@"login.error.oauth.expired", nil);
		}
		
		TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil)
														   message:message];
		[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
		[alertView show];
		
		[[GoogleAnalytics sharedInstance] sendAppEvent:@"OAuthTokenError" withLabel:[NSString stringWithFormat:@"code: %lu", (long)error.code]];
		
		return;
	}
	
	dispatch_async(dispatch_get_main_queue(), ^{
		__weak typeof(self) weakSelf = self;
		[weakSelf.loginHelper preformOAuthLoginWithToken:auth.accessToken
												provider:@"Google"
									  keepPendingPayment:NO
									navigationController:weakSelf.navigationController
											 objectModel:weakSelf.objectModel
											successBlock:^{
												[[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"OAuth"];
												[weakSelf processSuccessfulLogin:NO];
											}
											  errorBlock:^{
												  [[GPPSignIn sharedInstance] signOut];
											  }
							   waitForDetailsCompletions:YES];
	});
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
	{
        [self.passwordTextField becomeFirstResponder];
    }
	else
	{
        [textField resignFirstResponder];
    }
	
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if (textField == self.emailTextField)
	{
		NSString *modified = [textField.text stringByReplacingCharactersInRange:range withString:string];
		textField.text = [modified lowercaseString];
        [textField moveCaretToAfterRange:NSMakeRange(range.location, string.length)];
		
		return NO;
	}
	else
	{
		return YES;
	}
}

#pragma mark - Login
- (IBAction)loginPressed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
		__weak typeof(self) weakSelf = self;
		[self.loginHelper validateInputAndPerformLoginWithEmail:self.emailTextField.text
													   password:self.passwordTextField.text
                                             keepPendingPayment:NO
									   navigationControllerView:self.navigationController.view
													objectModel:self.objectModel
												   successBlock:^{
                                                       [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"tw"];
													   [weakSelf processSuccessfulLogin:YES];
												   }
									  waitForDetailsCompletions:YES];
    });
}

-(void)processSuccessfulLogin:(BOOL)useTouchId
{
    if(useTouchId && [TouchIDHelper isTouchIdAvailable] && ![TouchIDHelper isTouchIdSlotTaken] && [TouchIDHelper shouldPromptForUsername:self.emailTextField.text])
    {
        TouchIdPromptViewController* prompt = [[TouchIdPromptViewController alloc] init];
        prompt.touchIdDelegate = self;
        [prompt presentOnViewController:self.navigationController.parentViewController
						   withUsername:self.emailTextField.text
							   password:self.passwordTextField.text];
    }
    else
    {
        [AuthenticationHelper proceedFromSuccessfulLoginFromViewController:self
															   objectModel:self.objectModel];
    }
}

- (IBAction)googleLoginPressed:(id)sender
{
	if(![[GPPSignIn sharedInstance] hasAuthInKeychain] || ![[GPPSignIn sharedInstance] trySilentAuthentication])
	{
		[[GPPSignIn sharedInstance] authenticate];
	}
}

- (IBAction)yahooLogInPressed:(id)sender
{
    [self presentOpenIDLogInWithProvider:@"yahoo" name:@"Yahoo"];
}

- (void)presentOpenIDLogInWithProvider:(NSString *)provider name:(NSString *)providerName
{
    OpenIDViewController *controller = [[OpenIDViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setProvider:provider];
    //FYI: this is a concious decision not to add email to open id any more
    [controller setProviderName:providerName];
    [self.navigationController pushViewController:controller
										 animated:YES];
}

#pragma mark - Password reset
- (void)forgotPasswordTapped
{
    ResetPasswordViewController *controller = self.xibNameForResetPassword?[[ResetPasswordViewController alloc] initWithNibName:self.xibNameForResetPassword bundle:nil]:[[ResetPasswordViewController alloc] init];
    [controller setObjectModel:self.objectModel];
	controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resetEmailSent:(NSString *)email
{
	self.emailTextField.text = email;
}

- (IBAction)touchIdTapped:(id)sender
{
    [TouchIDHelper retrieveStoredCredentials:^(BOOL success, NSString *username, NSString *password) {
        if(success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [self.loginHelper validateInputAndPerformLoginWithEmail:username
                                                               password:password
                                                     keepPendingPayment:NO
                                               navigationControllerView:self.navigationController.view
                                                            objectModel:self.objectModel
                                                           successBlock:^{
                                                               
                                                               [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"touchID"];
															   [weakSelf processSuccessfulLogin:NO];
                                                           }
                                                             errorBlock:^(NSError *error) {
                                                                 //Error logging in with stored credentials
                                                                 TRWAlertView *alertView;
                                                                 if ([error isTransferwiseError])
                                                                 {
                                                                     BOOL isIncorrectCredentials = NO;
                                                                     if (error.code == ResponseCumulativeError)
																	 {
                                                                         NSArray *errors = error.userInfo[TRWErrors];
                                                                         for (NSDictionary *error in errors)
																		 {
                                                                             NSString *code = error[@"code"];
                                                                             if ([@"CRD_NOT_VALID" caseInsensitiveCompare:code] == NSOrderedSame)
                                                                             {
                                                                                 isIncorrectCredentials = YES;
                                                                                 break;
                                                                             }
                                                                         }
                                                                         
                                                                         NSString *message = [error localizedTransferwiseMessage];
                                                                         if(isIncorrectCredentials)
                                                                         {
                                                                             //The stored credentials are no longer valid. Clear!
                                                                             [TouchIDHelper clearCredentials];
                                                                             message = [message stringByAppendingString:@"\n"];
                                                                             message = [message stringByAppendingString:NSLocalizedString(@"touchid.cleared", nil)];
                                                                             [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginIncorrectCredentialsTouchID" withLabel:message];
                                                                             self.touchIdButton.hidden = YES;
                                                                         }
                                                                         else
                                                                         {
                                                                              [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginErrorTouchID" withLabel:error.localizedDescription];
                                                                         }
                                                                         alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:message];
                                                                     }
                                                                     else
                                                                     {
                                                                         alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil)
                                                                                                              message:NSLocalizedString(@"login.error.generic.message", nil)];
                                                                         [[GoogleAnalytics sharedInstance] sendAlertEvent:@"LoginErrorTouchID" withLabel:error.localizedDescription];
                                                                     }
                                                                     
                                                                     [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                                                                     
                                                                     [alertView show];
                                                                 }
                                                             }
                                                             waitForDetailsCompletions:YES];
            });
        }
    }];
    
}

-(void)touchIdPromptIsFinished:(TouchIdPromptViewController *)controller
{
    [AuthenticationHelper proceedFromSuccessfulLoginFromViewController:self objectModel:self.objectModel];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

@end
