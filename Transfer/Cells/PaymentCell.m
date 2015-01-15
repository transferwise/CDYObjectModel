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

- (void)configureWithPayment:(Payment *)payment
		 willShowActionButtonBlock:(TRWActionBlock)willShowCancelBlock
		  didShowActionButtonBlock:(TRWActionBlock)didShowCancelBlock
		  didHideActionButtonBlock:(TRWActionBlock)didHideCancelBlock
		   actionTappedBlock:(TRWActionBlock)cancelTappedBlock;
{
	//configure swipe to cancel
    [super configureWithActionButtonFromColor:[UIColor colorFromStyle:payment.status == PaymentStatusTransferred?@"TWElectricBlueDarker":@"RedShadow"]
                                      toColor:[UIColor colorFromStyle:payment.status == PaymentStatusTransferred?@"TWElectricBlue":@"Red"]
                    willShowActionButtonBlock:willShowCancelBlock
						 didShowActionButtonBlock:didShowCancelBlock
						 didHideActionButtonBlock:didHideCancelBlock
						  actionTappedBlock:cancelTappedBlock];
	
    [self.nameLabel setText:[payment.recipient name]];
    [self.statusLabel setText:[payment localizedStatus]];
    
    PaymentStatus status = [payment status];
    if(status != PaymentStatusCancelled && status != PaymentStatusRefunded)
    {
        [self.moneyLabel setText:[payment transferredAmountString]];
        [self.currencyLabel setText:[payment transferredCurrenciesString]];
    }
    else
    {
        [self.moneyLabel setText:@""];
        [self.currencyLabel setText:@""];
    }
    
    UIImage *icon;
    switch (status) {
        case PaymentStatusCancelled:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusMatched:
           icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusReceived:
            icon = [UIImage imageNamed:@"transfers_icon_converting"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusRefunded:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusReceivedWaitingRecipient:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusSubmitted:
			icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canPerformAction = YES;
            self.actionButtonTitle = NSLocalizedString(@"button.title.cancel", nil);
            break;
        case PaymentStatusUserHasPaid:
            icon = [UIImage imageNamed:@"transfers_icon_waiting"];
			self.canPerformAction = NO;
            break;
        case PaymentStatusTransferred:
            icon = [UIImage imageNamed:@"transfers_icon_complete"];
			self.canPerformAction = YES;
            self.actionButtonTitle = NSLocalizedString(@"button.title.repeat", nil);
            break;
        case PaymentStatusUnknown:
        default:
            icon = [UIImage imageNamed:@"transfers_icon_cancelled"];
            self.canPerformAction = NO;
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
        conditionalColor = [UIColor colorFromStyle:@"DarkFont"];
    }
    
    self.moneyLabel.textColor = conditionalColor;
    self.nameLabel.textColor = conditionalColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.slidingContentView.bgStyle = selected ? @"LightBlueHighlighted" : @"white";
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.slidingContentView.bgStyle = highlighted ? @"LightBlueHighlighted" : @"white";
}
@end
