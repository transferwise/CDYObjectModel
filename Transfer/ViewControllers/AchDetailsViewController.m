//
//  AchDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 18.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchDetailsViewController.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "GoogleAnalytics.h"
#import "SupportCoordinator.h"
#import "Payment.h"
#import "FloatingLabelTextField.h"
#import "NavigationBarCustomiser.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"

IB_DESIGNABLE

@interface AchDetailsViewController ()

@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) GetLoginFormBlock loginFormBlock;

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *routingNumberTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *accountNumberTextField;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation AchDetailsViewController

- (instancetype)initWithPayment:(Payment *)payment
					objectModel:(ObjectModel *)objectModel
				 loginFormBlock:(GetLoginFormBlock)loginFormBlock
{
	self = [super init];
	
	if (self)
	{
		self.payment = payment;
		self.objectModel = objectModel;
		self.loginFormBlock = loginFormBlock;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:NSLocalizedString(@"ach.controller.title", nil)];
	[self.supportButton setTitle:NSLocalizedString([@"ach.controller.button.support" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	[self.connectButton setTitle:NSLocalizedString(@"ach.controller.button.connect", nil) forState:UIControlStateNormal];
	
	[self.routingNumberTextField setTitle:NSLocalizedString(@"ach.controller.routing.label", nil)];
	self.routingNumberTextField.delegate = self;
	[self.routingNumberTextField setReturnKeyType:UIReturnKeyNext];
	
	[self.accountNumberTextField setTitle:NSLocalizedString(@"ach.controller.account.label", nil)];
	self.accountNumberTextField.delegate = self;
	[self.accountNumberTextField setReturnKeyType:UIReturnKeyDone];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.routingNumberTextField)
	{
		[self.accountNumberTextField becomeFirstResponder];
	}
	else
	{
		[textField resignFirstResponder];
	}
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSInteger maxLength = kMaxAchRoutingLength;
	
	if (textField == self.accountNumberTextField)
	{
		maxLength = kMaxAchAccountlength;
	}
	
	NSString *modified = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	return modified.length <= maxLength;
}

#pragma mark - Button Actions
- (IBAction)contactSupportPressed:(id)sender
{
	[[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"Ach details"];
	NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
	[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

- (IBAction)connectPressed:(id)sender
{
	NSString* errors = [self isValid];
	
	if (errors == nil)
	{
		TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
		[hud setMessage:NSLocalizedString(@"ach.controller.accessing", nil)];
		
		self.loginFormBlock(self.accountNumberTextField.text, self.routingNumberTextField.text, hud);
	}
	else
	{
		TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.error.title", nil) message:errors];
		[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
		[alertView show];
	}
}

#pragma mark - Validation
- (NSString *)isValid
{
	NSMutableString *errors = [[NSMutableString alloc] init];
	
	if (![self.routingNumberTextField.text hasValue]
		|| ![self.routingNumberTextField.text isValidAchRoutingNumber])
	{
		[errors appendIssue:NSLocalizedString(@"ach.controller.validation.routing.invalid", nil)];
	}
	
	if (![self.accountNumberTextField.text hasValue]
		|| ![self.accountNumberTextField.text isValidAchAccountNumber])
	{
		[errors appendIssue:NSLocalizedString(@"ach.controller.validation.account.invalid", nil)];
	}
	
	if (errors.length > 0)
	{
		return errors;
	}
	
	return nil;
}

@end
