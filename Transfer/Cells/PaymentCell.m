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
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonLeft;

@end

@implementation PaymentCell

- (void)configureWithPayment:(Payment *)payment {
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.currencyLabel setText:[payment transferredCurrenciesString]];
    
    UIImage *icon;
    switch ([payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_icon_canceled"];
            break;
        case PaymentStatusMatched:
           icon = [UIImage imageNamed:@"transfers_icon_converting"];
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_icon_converting"];
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_icon_canceled"];
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
            icon = [UIImage imageNamed:@"transfers_icon_canceled"];
            
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.contentView.bgStyle=selected?@"cellSelected":@"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.bgStyle=highlighted?@"cellSelected":@"white";
}

- (void)showCancelButton:(BOOL)animated
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.2 animations:^{
		self.cancelButtonLeft.constant = 500;
		[self.moneyLabel setHidden:YES];
		[self.currencyLabel setHidden:YES];
		[self.contentView layoutIfNeeded];
	}];
}

- (void)hideCancelButton:(BOOL)animated
{
	[self.contentView layoutIfNeeded];
	[UIView animateWithDuration:0.2 animations:^{
		self.cancelButtonLeft.constant = 0;
		[self.moneyLabel setHidden:NO];
		[self.currencyLabel setHidden:NO];
		[self.contentView layoutIfNeeded];
	}];
}

@end
