//
//  WhyAlertView.m
//  Transfer
//
//  Created by Henri Mägi on 19.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "WhyView.h"
#import "TransferCalculationsOperation.h"
#import "CalculationResult.h"

@interface WhyView ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;

@property (nonatomic, weak) IBOutlet UIImageView * transferWiseHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *transferwiseRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferwiseTransferFeeLabel;
@property (nonatomic, weak) IBOutlet UILabel *twTransferRateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *twFeeTitleLabel;


@property (nonatomic, weak) IBOutlet UIImageView * bankHeaderImage;
@property (nonatomic, weak) IBOutlet UILabel *bankHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankTransferFeeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bankTransferRateTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *bankFeeTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *vsLabel;
@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@property (nonatomic, weak) IBOutlet UILabel *feeLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;





@end

@implementation WhyView


- (void)awakeFromNib {
    self.twTransferRateTitleLabel.text = NSLocalizedString(@"why.popup.tw.rate.title", nil);
    self.bankTransferRateTitleLabel.text = NSLocalizedString(@"why.popup.bank.rate.title", nil);
    self.bankHeaderLabel.text = NSLocalizedString(@"why.popup.bank.column.label",nil);
    self.twFeeTitleLabel.text = NSLocalizedString(@"why.popup.tw.fee.title", nil);
    self.bankFeeTitleLabel.text = NSLocalizedString(@"why.popup.bank.fee.title", nil);
    self.vsLabel.text = NSLocalizedString(@"why.popup.vs", nil);
    self.rateLabel.text = NSLocalizedString(@"why.popup.rate", nil);
    self.feeLabel.text = NSLocalizedString(@"why.popup.fee", nil);
    self.titleLabel.text = NSLocalizedString(@"why.popup.title", nil);
}


- (void)setupWithResult:(CalculationResult *)result {
    [self.transferwiseTransferFeeLabel setText:result.transferwiseTransferFeeStringWithCurrency];
    [self.bankRateLabel setText:result.bankRateString];
    self.transferwiseRateLabel.text = result.transferwiseRateString;
    [self.bankTransferFeeLabel setText:result.bankTotalFeeStringWithCurrency];

    if (result.amountCurrency == SourceCurrency) {
        [self.actionButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"why.popup.button",nil),result.receiveWinAmountWithCurrency] forState:UIControlStateNormal];
    } else {
        [self.actionButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"why.popup.button",nil),result.payWinAmountWithCurrency] forState:UIControlStateNormal];
    }
}

- (void)setColor:(UIColor *)color {
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UILabel class]]) {
            continue;
        }

        UILabel *label = (UILabel *) view;
        [label setTextColor:color];
    }
}

@end
