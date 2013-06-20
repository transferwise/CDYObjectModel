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
@property (strong, nonatomic) IBOutlet UILabel *transferwiseRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferwiseTransferFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferwisePayOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankTransferFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankPayOutLabel;

@property (nonatomic, strong) IBOutlet UILabel *bankColumnTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *twTransferRateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankTransferRateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *twFeeTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankFeeTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *twYouGetTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankYouGetTitleLabel;


@end

@implementation WhyView

- (id)init {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WhyView" owner:self options:nil];
    self = (WhyView *) [nib objectAtIndex:0];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [self.bankColumnTitleLabel setText:NSLocalizedString(@"why.popup.bank.column.label", nil)];
    [self.twTransferRateTitleLabel setText:NSLocalizedString(@"why.popup.tw.rate.title", nil)];
    [self.bankTransferRateTitleLabel setText:NSLocalizedString(@"why.popup.bank.rate.title", nil)];
    [self.twFeeTitleLabel setText:NSLocalizedString(@"why.popup.tw.fee.title", nil)];
    [self.bankFeeTitleLabel setText:NSLocalizedString(@"why.popup.bank.fee.title", nil)];
}


- (void)setupWithResult:(CalculationResult *)result {
    [self.transferwiseRateLabel setText:result.transferwiseRateString];
    [self.transferwiseTransferFeeLabel setText:result.transferwiseTransferFeeStringWithCurrency];
    [self.bankRateLabel setText:result.bankRateString];
    [self.bankTransferFeeLabel setText:result.bankTotalFeeStringWithCurrency];

    if (result.amountCurrency == SourceCurrency) {
        [self.transferwisePayOutLabel setText:result.transferwisePayOutStringWithCurrency];
        [self.bankPayOutLabel setText:result.bankPayOutStringWithCurrency];
        [self.twYouGetTitleLabel setText:NSLocalizedString(@"why.popup.tw.you.get.title", nil)];
        [self.bankYouGetTitleLabel setText:NSLocalizedString(@"why.popup.bank.you.get.title", nil)];
    } else {
        [self.transferwisePayOutLabel setText:result.transferwisePayInStringWithCurrency];
        [self.bankPayOutLabel setText:result.bankPayInStringWithCurrency];
        [self.twYouGetTitleLabel setText:NSLocalizedString(@"why.popup.tw.you.pay.title", nil)];
        [self.bankYouGetTitleLabel setText:NSLocalizedString(@"why.popup.bank.you.pay.title", nil)];
    }
}

@end
