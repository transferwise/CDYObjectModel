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
@end

@implementation WhyView

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WhyView" owner:self options:nil];
    self = (WhyView*)[nib objectAtIndex:0];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setupWithResult:(CalculationResult*)result
{
    [self.transferwisePayOutLabel setText:result.transferwisePayOutStringWithCurrency];
    [self.transferwiseRateLabel setText:result.transferwiseRateString];
    [self.transferwiseTransferFeeLabel setText:result.transferwiseTransferFeeStringWithCurrency];
    [self.bankPayOutLabel setText:result.bankPayOutStringWithCurrency];
    [self.bankRateLabel setText:result.bankRateString];
    [self.bankTransferFeeLabel setText:result.bankTransferFeeStringWithCurrency];
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Get %@ more vs a bank", @"Why popup"), result.savedAmountWithCurrency];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
