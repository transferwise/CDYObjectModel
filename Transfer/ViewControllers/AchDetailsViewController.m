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

IB_DESIGNABLE

@interface AchDetailsViewController ()

@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) ObjectModel *objectModel;

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *routingNumberTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *accountNumberTextField;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation AchDetailsViewController

- (instancetype)initWithPayment:(Payment *)payment
					objectModel:(ObjectModel *)objectModel
{
	self = [super init];
	
	if (self)
	{
		self.payment = payment;
		self.objectModel = objectModel;
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

#pragma mark - Button Actions
- (IBAction)contactSupportPressed:(id)sender
{
	[[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"Ach details"];
	NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
	[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
