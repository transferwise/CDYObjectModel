//
//  ResetPasswordViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ResetPasswordViewController.h"
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

@interface ResetPasswordViewController ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *emailTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorViewHeight;
@property (strong, nonatomic) IBOutlet GreenButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ResetPasswordViewController

- (id)init {
    self = [super initWithNibName:@"ResetPasswordViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[NavigationBarCustomiser setWhite];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController
																									   isBlue:YES]];
	
	[self.emailTextField configureWithTitle:NSLocalizedString(@"reset.password.controller.email.cell.label", nil) value:@""];
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
	[self.emailTextField setReturnKeyType:UIReturnKeyDone];
	self.emailTextField.delegate = self;

	[self.continueButton setTitle:NSLocalizedString(@"reset.controller.footer.button.title", nil) forState:UIControlStateNormal];
	
	[self.messageLabel setText:NSLocalizedString([@"reset.password.header.description" deviceSpecificLocalization], nil)];
	NSLog(@"%@", NSLocalizedString([@"reset.password.header.description" deviceSpecificLocalization], nil));
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setTitle:NSLocalizedString(@"reset.password.controller.title", nil)];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[NavigationBarCustomiser setDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)resetPasswordPressed
{
    NSString *email = self.emailTextField.text;
    if (![email hasValue])
	{
        [self showError:NSLocalizedString(@"reset.password.email.not.entered", nil)];
        return;
    }
	else if (![email isValidEmail])
	{
        [self showError:NSLocalizedString(@"reset.password.invaild.email.error", nil)];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    ResetPasswordOperation *operation = [[ResetPasswordOperation alloc] init];
    [operation setEmail:email];
    [operation setObjectModel:self.objectModel];
    [operation setResultHandler:^(NSError *error) {
        [hud hide];
        if (!error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.success.alert.title", nil) message:NSLocalizedString(@"reset.password.success.alert.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"reset.password.alert.dismiss.button", nil) action:^{
				[self.delegate resetEmailSent:email];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView show];
            return;
        }

        if (error.twCodeNotFound) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.failed.alert.title", nil) message:NSLocalizedString(@"reset.password.not.found.alert.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"reset.password.alert.dismiss.button", nil)];
            [alertView show];
        } else {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"reset.password.failed.alert.title", nil) error:error];
            [alertView show];
        }
    }];
    [operation execute];
}

- (void)showError:(NSString *)message {
    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"reset.password.error.title", nil) message:message];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    [alertView show];
}

@end
