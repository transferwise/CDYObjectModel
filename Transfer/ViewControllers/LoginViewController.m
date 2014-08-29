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

@end

@implementation LoginViewController

#pragma mark - Init
- (id)init
{
    self = [super initWithNibName:@"LoginViewController" bundle:nil];
    if (self)
	{
        self.loginHelper = [[LoginHelper alloc] init];
    }
    return self;
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

#pragma mark - Login
- (IBAction)loginPressed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[self.loginHelper validateInputAndPerformLoginWithEmail:self.emailTextField.text
													   password:self.passwordTextField.text
									   navigationControllerView:self.navigationController.view
													objectModel:self.objectModel
												   successBlock:^{
													   [self dismissViewControllerAnimated:YES completion:nil];
												   }
									  waitForDetailsCompletions:NO];
    });
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
@end
