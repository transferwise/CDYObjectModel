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

@interface PaymentCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusIcon;

@end

@implementation PaymentCell

- (void)prepareForReuse
{
	[super prepareForReuse];
	[self.moneyLabel setHidden:NO];
	[self.currencyLabel setHidden:NO];
}

- (void)configureWithPayment:(Payment *)payment
		 willShowCancelBlock:(TRWActionBlock)willShowCancelBlock
		  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
		  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock;
{
	//configure swipe to cancel
	[super configureWithWillShowCancelBlock:willShowCancelBlock
						 didShowCancelBlock:didShowCancelBlock
						 didHideCancelBlock:didHideCancelBlock
						  cancelTappedBlock:cancelTappedBlock];
	
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    [self.moneyLabel setText:[payment transferredAmountString]];
    [self.currencyLabel setText:[payment transferredCurrenciesString]];
    
    UIImage *icon;
    switch ([payment status]) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusMatched:
           icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusSubmitted:
			icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canBeCancelled = YES;
            break;
        case PaymentStatusUserHasPaid:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_icon_complete"];
			self.canBeCancelled = NO;
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            self.canBeCancelled = NO;
            break;
    }
    
    self.statusIcon.image = icon;
    
    UIColor * conditionalColor;
    if(payment.isCancelled)
    {
        conditionalColor = [UIColor colorFromStyle:@"CoreFont"];
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
    self.contentView.bgStyle = selected ? @"cellSelected" : @"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.contentView.bgStyle = highlighted ? @"cellSelected" : @"white";
}
@end
