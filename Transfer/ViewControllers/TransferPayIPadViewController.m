//
//  TransferPayIPadViewController.m
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferPayIPadViewController.h"
#import "TransferDetialsHeaderView.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "GreenButton.h"
#import "GoogleAnalytics.h"
#import "SupportCoordinator.h"

@interface TransferPayIPadViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet GreenButton *payButton;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation TransferPayIPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpHeader
{
	[self.payButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.button.pay", nil), [self.payment payInStringWithCurrency]]
					forState:UIControlStateNormal];
	[self.cancelButton setTitle:NSLocalizedString(@"transferdetails.controller.button.cancel", nil) forState:UIControlStateNormal];
	
	[super setUpHeader];
}

- (void)setUpAmounts
{
	//empty so nothing gets initialized
}

- (void)setUpAccounts
{
	//empty so nothing gets initialized
}

- (IBAction)payTapped:(id)sender
{
	
}

- (IBAction)cancelTapped:(id)sender
{
	[self.delegate cancelPaymentWithConfirmation:self.payment];
}

- (IBAction)contactSupportPressed
{
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"view transfer"];
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}
@end
