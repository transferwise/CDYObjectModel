//
//  PaymentCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentCell.h"
#import "Payment.h"
#import "Recipient.h"
#import "MOMStyle.h"
#import "Constants.h"

@interface PaymentCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@end

@implementation PaymentCell



- (void)configureWithPayment:(Payment *)payment {
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.currencyLabel setText:[payment transferredCurrenciesString]];
    
    UIImage *icon;
    switch (PaymentStatusRefunded){//[payment status]) {
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
    
    UIColor * conditionalColor;
    if(payment.isCancelled)
    {
        conditionalColor = [UIColor colorFromStyle:@"lightText"];
    }
    else
    {
        conditionalColor = [UIColor colorFromStyle:@"darkText"];
    }
    
    self.moneyLabel.textColor = conditionalColor;
    self.nameLabel.textColor = conditionalColor;
    
}

@end
