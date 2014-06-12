//
//  TransferDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetailsViewController.h"
#import "TransferDetailsAmountsView.h"

@interface TransferDetailsViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet TransferDetailsAmountsView *amountsView;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;

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
	self.headerPlaceholder = self.headerView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithPayment:(Payment *)payment
{
	self.headerView.transferNumber = [payment.remoteId stringValue];
    self.headerView.recipientName = [payment.recipient name];
    
    switch ([payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_status_cancelled"];
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
            icon = [UIImage imageNamed:@"transfers_status_cancelled"];
            
            break;
    }
    self.statusIcon.image = icon;
	self.headerView.status = [self getStatusBasedLocalizations:@"payment.status.%@.description.long"
														status:payment.paymentStatus];;
	
	self.amountsView.fromAmount = [payment payInStringWithCurrency];
	self.amountsView.status = [self getStatusBasedLocalizations:@"payment.status.%@.description.conversion"
														 status:payment.paymentStatus];;
	self.amountsView.toAmount = [payment payOutStringWithCurrency];
	self.amountsView.eta = [self getStatusBasedLocalizations:@"payment.status.%@.description.eta"
													  status:payment.paymentStatus];;
}

- (NSString*)getStatusBasedLocalizations:(NSString *)localizationKey status:(NSString)status
{
	return NSLocalizedString([NSString stringWithFormat:localizationKey, status], nil);
}

@end
