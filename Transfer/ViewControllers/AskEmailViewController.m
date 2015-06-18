//
//  ResetPasswordViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AskEmailViewController.h"
#import "TransferBackButtonItem.h"
#import "UIColor+Theme.h"
#import "UIView+Loading.h"
#import "NSString+Validation.h"
#import "TRWProgressHUD.h"
#import "ResetPasswordOperation.h"
#import "TRWAlertView.h"
#import "NSError+TRWErrors.h"
#import "FloatingLabelTextField.h"
#import "GreenButton.h"
#import "NavigationBarCustomiser.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "GoogleAnalytics.h"

@interface AskEmailViewController ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorViewHeight;
@property (strong, nonatomic) IBOutlet GreenButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, copy) AskEmailReturnBlock returnBlock;

@end

@implementation AskEmailViewController

- (id)initWithReturnBlock:(AskEmailReturnBlock)returnBlock
{
	NSAssert(returnBlock, @"returnBlock can't be nil");
	
    self = [super initWithNibName:@"AskEmailViewController" bundle:nil];
    if (self)
	{
		self.returnBlock = returnBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[NavigationBarCustomiser setWhite];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController
																									   isBlue:YES]];
	
	[self.emailTextField configureWithTitle:NSLocalizedString(@"ask.email.controller.email.cell.label", nil) value:@""];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
	[self.emailTextField setReturnKeyType:UIReturnKeyDone];
	[self.emailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
	self.emailTextField.delegate = self;

	[self.continueButton setTitle:NSLocalizedString(@"ask.email.controller.footer.button.title", nil) forState:UIControlStateNormal];
	
    [self.messageLabel setText:NSLocalizedString([@"ask.email.header.description" deviceSpecificLocalization], nil)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:NSLocalizedString(@"ask.email.controller.title", nil)];
    [[GoogleAnalytics sharedInstance] sendScreen:GAResetPassword];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[NavigationBarCustomiser setDefault];
	[super viewDidDisappear:animated];
}

- (void)updateViewConstraints
{
	self.separatorViewHeight.constant = 1.0f / [[UIScreen mainScreen] scale];
	
	[super updateViewConstraints];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
    return YES;
}

#pragma mark - Reset Password
- (IBAction)donePressed
{
    NSString *email = self.emailTextField.text;
    if (![email hasValue])
	{
        [self showError:NSLocalizedString(@"ask.email.email.not.entered", nil)];
        return;
    }
	else if (![email isValidEmail])
	{
        [self showError:NSLocalizedString(@"ask.email.invaild.email.error", nil)];
        return;
    }

	self.returnBlock(email);
}

- (void)showError:(NSString *)message
{
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ask.email.error.title", nil) message:message];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    [alertView show];
}

@end
