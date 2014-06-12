//
//  TransferDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetailsViewController.h"

@interface TransferDetailsViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerPlaceholder;
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
    self.headerView.recipientName = [payment.recipient name];
	self.headerView.status = [payment localizedStatus];
	
//    [self.moneyLabel setText:[payment transferredAmountString]];
//    [self.currencyLabel setText:[payment transferredCurrenciesString]];
    
    UIImage *icon;
    switch ([payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            break;
        case PaymentStatusMatched:
			icon = [UIImage imageNamed:@"transfers_icon_converting"];
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_icon_converting"];
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
            break;
        case PaymentStatusSubmitted:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_icon_complete"];
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            
            break;
    }
    
    self.statusIcon.image = icon;    
}

@end
