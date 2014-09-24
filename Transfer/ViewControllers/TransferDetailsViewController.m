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
#import "TransferBackButtonItem.h"
#import "BlueButton.h"

@interface TransferDetailsViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet TransferDetailsAmountsView *amountsView;
@property (strong, nonatomic) IBOutlet TransferDetialsRecipientView *accountView;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@end

@implementation TransferDetailsViewController

- (void)setPayment:(Payment *)payment
{
	_payment = payment;
	[self setTitle:[self getStatusBasedLocalization:@"transferdetails.controller.%@.header"
											 status:self.payment.paymentStatus]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setBackOrCloseButton];
	[self setData];
}

- (void)setBackOrCloseButton
{
	if (self.showClose)
	{
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
		[button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
		UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];
		[self.navigationItem setLeftBarButtonItem:settingsButton];
	}
	else
	{
		[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
	}
}

- (void)dismiss
{
	[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
}

- (void)setData
{
	[self setUpHeader];
	[self setUpAmounts];
	[self setUpAccounts];
    
	UIImage *icon;
    switch ([self.payment status]) {
        case PaymentStatusRefunded:
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_status_cancelled"];
            break;
        case PaymentStatusMatched:
			icon = [UIImage imageNamed:@"transfers_status_converting"];
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_status_converting"];
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_status_waiting"];
            break;
        case PaymentStatusSubmitted:
        case PaymentStatusUserHasPaid:
            icon = [UIImage imageNamed:@"transfers_status_waiting"];
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_status_complete"];
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_status_cancelled"];
            
            break;
    }
    self.statusIcon.image = icon;
	
	if (self.payment.status == PaymentStatusTransferred)
	{
		[self.supportButton setTitle:NSLocalizedString([@"transferdetails.controller.button.rate" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	}
	else
	{
		[self.supportButton setTitle:NSLocalizedString([@"transferdetails.controller.button.support" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	}
	
	[self.view layoutIfNeeded];
}

- (void)setUpHeader
{
	self.headerView.transferNumber = [self.payment.remoteId stringValue];
	self.headerView.recipientName = [self.payment.recipient name];
	self.headerView.status = [self getStatusBasedLocalization:@"payment.status.%@.description.long"
													   status:self.payment.paymentStatus];
	//waiting has a two-line status
	if (self.payment.status == PaymentStatusSubmitted
		|| self.payment.status == PaymentStatusUserHasPaid)
	{
		self.headerView.statusWaiting = NSLocalizedString(@"payment.status.submitted.description.long2", nil);
	}
	
}

- (void)setUpAmounts
{
	self.amountsView.fromAmount = [self.payment payInStringWithCurrency];
	self.amountsView.status = [self getStatusBasedLocalization:@"payment.status.%@.description.conversion"
														 status:self.payment.paymentStatus];
    if(self.payment.status != PaymentStatusRefunded)
    {
        self.amountsView.toAmount = [self.payment payOutStringWithCurrency];
    }
    else
    {
         self.amountsView.toAmount = @"";
    }
	
	//transferred needs special handling
	//delivery estimator returns dates in the future or today FOREVER, hence this nice comparison
	if (self.payment.status == PaymentStatusTransferred
		&& [[[self class] getDateWithoutTime:self.payment.estimatedDelivery] compare:[[self class] getDateWithoutTime:[NSDate date]]] == NSOrderedSame)
	{
		self.amountsView.shouldArrive = NSLocalizedString(@"payment.status.transferred.description.eta.past", nil);
		self.amountsView.eta = [self.payment latestChangeTimeString];
	}
	else
	{
		NSString* eta = NSLocalizedString([self getStatusBasedLocalization:@"payment.status.%@.description.eta"
																	status:self.payment.paymentStatus], nil);
		
		if(eta.length > 0 && self.payment.paymentDateString != nil)
		{
			self.amountsView.shouldArrive = eta;
			self.amountsView.eta = self.payment.estimatedDeliveryStringFromServer;
		}
		else
		{
			self.amountsView.shouldArrive = nil;
			self.amountsView.eta = nil;
		}
	}
}

- (void)setUpAccounts
{
	[self.accountView configureWithRecipient:self.payment.recipient];
}

- (IBAction)contactSupportPressed
{
	if (self.payment.status == PaymentStatusTransferred)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:TRWRateAppUrl]];
	}
	else
	{
		[[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"Transfer details"];
		NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
		[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
	}
}

- (NSString*)getStatusBasedLocalization:(NSString *)localizationKey status:(NSString*)status
{
	NSString *key = [NSString stringWithFormat:localizationKey, status];
	return NSLocalizedString(key, nil);
}

+ (NSDate *)getDateWithoutTime:(NSDate *)date
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
													fromDate:date];
	
	return [calendar dateFromComponents:components];
}

@end
