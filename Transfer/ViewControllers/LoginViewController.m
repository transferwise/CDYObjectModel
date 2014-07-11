//
//  LgoinViewController.m
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
#import "UIApplication+Keyboard.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "LoginOperation.h"
#import "NSString+Validation.h"
#import "NSError+TRWErrors.h"
#import "LoginOperation.h"
#import "NSMutableString+Issues.h"
#import "OpenIDViewController.h"
#import "ResetPasswordViewController.h"
#import "UIFont+MOMStyle.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet GreenButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;
@property (strong, nonatomic) IBOutlet GreenButton *googleLoginButton;
@property (strong, nonatomic) IBOutlet GreenButton *yahooLoginButton;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;

@end

@implementation LoginViewController

#pragma mark - Init
- (id)init
{
    self = [super initWithNibName:@"LoginViewController2" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life-cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
	
	[self.emailTextField configureWithTitle:NSLocalizedString(@"login.email.field.title", nil) value:@""];
	self.emailTextField.delegate = self;
	[self.emailTextField setReturnKeyType:UIReturnKeyNext];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
	
	[self.passwordTextField configureWithTitle:NSLocalizedString(@"login.password.field.title", nil) value:@""];
	self.passwordTextField.delegate = self;
	[self.passwordTextField setReturnKeyType:UIReturnKeyDone];
    [self.passwordTextField setSecureTextEntry:YES];
	
	[self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];
	
	[self.forgotPasswordLabel setText:NSLocalizedString(@"login.controller.forgot.password.link", nil)];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordTapped)];
    [self.forgotPasswordLabel addGestureRecognizer:tapGestureRecognizer];
	
	[self.googleLoginButton setTitle:NSLocalizedString(@"button.title.log.in.google", nil) forState:UIControlStateNormal];
	[self.yahooLoginButton setTitle:NSLocalizedString(@"button.title.log.in.yahoo", nil) forState:UIControlStateNormal];
	
	[self.orLabel setText:NSLocalizedString(@"login.controller.or", nil)];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:NSLocalizedString(@"login.controller.title", nil)];
	
//	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
	
    [[GoogleAnalytics sharedInstance] sendScreen:@"Login"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Login
- (IBAction)loginPressed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self validateInputAndPerformLogin];
    });
}

- (void)validateInputAndPerformLogin
{
    [UIApplication dismissKeyboard];
	
    NSString *issues = [self validateInput];
    if ([issues length] > 0)
	{
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"login.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
	
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"login.controller.logging.in.message", nil)];
	
    LoginOperation *loginOperation = [LoginOperation loginOperationWithEmail:[self.emailTextField text]
																	password:[self.passwordTextField text]];
    [self setExecutedOperation:loginOperation];
	
    [loginOperation setObjectModel:self.objectModel];
	
    [loginOperation setResponseHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
			
            if (!error)
			{
                [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"tw"];
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
			
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
        });
    }];
	
    [loginOperation execute];
}

- (NSString *)validateInput
{
    NSMutableString *issues = [NSMutableString string];
	
    NSString *email = [self.emailTextField text];
    NSString *password = [self.passwordTextField text];
	
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
    [controller setEmail:[self.emailTextField text]];
    [controller setProviderName:providerName];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)forgotPasswordTapped
{
    ResetPasswordViewController *controller = [[ResetPasswordViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
