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
#import "LoginHelper.h"
#import "TouchIDHelper.h"
#import "TouchIdPromptViewController.h"
#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"
#import "NetworkErrorCodes.h"
#import "TransferwiseOperation.h"
#import "MainViewController.h"
#import "ConnectionAwareViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet GreenButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (strong, nonatomic) IBOutlet GoogleButton *googleLoginButton;
@property (strong, nonatomic) IBOutlet YahooButton *yahooLoginButton;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *emailSeparatorHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *passwordSeparatorHeight;
@property (strong, nonatomic) LoginHelper *loginHelper;
@property (weak, nonatomic) IBOutlet UIButton *touchIdButton;

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
    _loginHelper = [[LoginHelper alloc] init];
}

#pragma mark - View Life-cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[NavigationBarCustomiser setWhite];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController
																									   isBlue:YES]];
	
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
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:NSLocalizedString(@"login.controller.title", nil)];
	
    [[GoogleAnalytics sharedInstance] sendScreen:@"Login"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[NavigationBarCustomiser setDefault];
}

- (void)updateViewConstraints
{
	self.passwordSeparatorHeight.constant = 1.0f / [[UIScreen mainScreen] scale];
	self.emailSeparatorHeight.constant = 1.0f / [[UIScreen mainScreen] scale];
	
	[super updateViewConstraints];
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
									   navigationControllerView:self.navigationController.view
													objectModel:self.objectModel
												   successBlock:^{
                                                       [weakSelf processSuccessfulLogin];
												   }
									  waitForDetailsCompletions:NO];
    });
}

-(void)processSuccessfulLogin
{
    if([TouchIDHelper isTouchIdAvailable] && ![TouchIDHelper isTouchIdSlotTaken] && [TouchIDHelper shouldPromptForUsername:self.emailTextField.text])
    {
        TouchIdPromptViewController* prompt = [[TouchIdPromptViewController alloc] init];
        [prompt presentOnViewController:self.navigationController.parentViewController withUsername:self.emailTextField.text password:self.passwordTextField.text];
    }
    else
    {
        [LoginHelper proceedFromSuccessfulLoginFromViewController:self objectModel:self.objectModel];
    }
}

- (IBAction)googleLogInPressed:(id)sender
{
    [self presentOpenIDLogInWithProvider:@"google" name:@"Google"];
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
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Password reset
- (void)forgotPasswordTapped
{
    ResetPasswordViewController *controller = [[ResetPasswordViewController alloc] init];
    [controller setObjectModel:self.objectModel];
	controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)resetEmailSent:(NSString *)email
{
	self.emailTextField.text = email;
}

- (IBAction)touchIdTapped:(id)sender {
    [TouchIDHelper retrieveStoredCredentials:^(BOOL success, NSString *username, NSString *password) {
        if(success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                [self.loginHelper validateInputAndPerformLoginWithEmail:username
                                                               password:password
                                               navigationControllerView:self.navigationController.view
                                                            objectModel:self.objectModel
                                                           successBlock:^{
                                                               [weakSelf processSuccessfulLogin];
                                                           }
                                                             errorBlock:^(NSError *error) {
                                                                 //Error logging in with stored credentials
                                                                 TRWAlertView *alertView;
                                                                 if ([error isTransferwiseError])
                                                                 {
                                                                     BOOL isIncorrectCredentials = NO;
                                                                     if (error.code == ResponseCumulativeError) {
                                                                         NSArray *errors = error.userInfo[TRWErrors];
                                                                         for (NSDictionary *error in errors) {
                                                                             NSString *code = error[@"code"];
                                                                             if ([code caseInsensitiveCompare:@"CRD_NOT_VALID"] == NSOrderedSame)
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
                                                             waitForDetailsCompletions:NO];
            });
        }
    }];
    
}
@end
