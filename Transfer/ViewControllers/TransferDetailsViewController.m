//
//  TransferDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "TransferDetialsHeaderView.h"
#import "TransferDetailsAmountsView.h"
#import "TransferDetialsRecipientView.h"
#import "Recipient.h"
#import "SupportCoordinator.h"
#import "GoogleAnalytics.h"
#import "NSString+DeviceSpecificLocalisation.h"

@interface TransferDetailsViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet TransferDetailsAmountsView *amountsView;
@property (strong, nonatomic) IBOutlet TransferDetialsRecipientView *accountView;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@end

@implementation TransferDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData
{
	[self setUpHeader];
	[self setUpAmounts];
	[self setUpAccounts];
    
	UIImage *icon;
    switch ([self.payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_status_canceled"];
            break;
        case PaymentStatusMatched:
			icon = [UIImage imageNamed:@"transfers_status_converting"];
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_status_converting"];
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_status_cancelled"];
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_status_waiting"];
            break;
        case PaymentStatusSubmitted:
            icon = [UIImage imageNamed:@"transfers_status_waiting"];
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_status_complete"];
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_status_canceled"];
            
            break;
    }
    self.statusIcon.image = icon;
	
	[self.supportButton setTitle:NSLocalizedString([@"transferdetails.controller.button.support" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	
	[self.view layoutIfNeeded];
}

- (void)setUpHeader
{
	self.headerView.transferNumber = [self.payment.remoteId stringValue];
	self.headerView.recipientName = [self.payment.recipient name];
	self.headerView.status = [self getStatusBasedLocalizations:@"payment.status.%@.description.long"
														status:self.payment.paymentStatus];
}

- (void)setUpAmounts
{
	self.amountsView.fromAmount = [self.payment payInStringWithCurrency];
	self.amountsView.status = [self getStatusBasedLocalizations:@"payment.status.%@.description.conversion"
														 status:self.payment.paymentStatus];
	self.amountsView.toAmount = [self.payment payOutStringWithCurrency];
	NSString* eta = NSLocalizedString([self getStatusBasedLocalizations:@"payment.status.%@.description.eta"
																 status:self.payment.paymentStatus], nil);
	if(eta.length > 0 && self.payment.paymentDateString != nil)
	{
		self.amountsView.shouldArrive = eta;
		self.amountsView.eta = self.payment.paymentDateString;
	}
	else
	{
		self.amountsView.shouldArrive = nil;
		self.amountsView.eta = nil;
	}
}

- (void)setUpAccounts
{
	[self.accountView configureWithRecipient:self.payment.recipient];
}

- (IBAction)contactSupportPressed {
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"view transfer"];
    NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
    [[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

- (NSString*)getStatusBasedLocalizations:(NSString *)localizationKey status:(NSString*)status
{
	NSString *key = [NSString stringWithFormat:localizationKey, status];
	return NSLocalizedString(key, nil);
}
@end
