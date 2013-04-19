//
//  WhyAlertView.m
//  Transfer
//
//  Created by Henri Mägi on 19.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "WhyAlertView.h"
#import "TransferCalculationsOperation.h"
#import "../../Thirdparty/TSAlertView/TSAlertView.h"
#import "CalculationResult.h"

@interface WhyAlertView ()
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;
@property (nonatomic, strong) NSString *title;
@end

@implementation WhyAlertView

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WhyAlertView" owner:self options:nil];
    self = (WhyAlertView*)[nib objectAtIndex:0];
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


- (void)showAlert
{
    NSString * sourceCurrency = @"GBP";
    NSString* targetCurrency = @"EUR";
    [self setAmountCurrency:SourceCurrency];
    TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:@"1000" source:sourceCurrency target:targetCurrency];
    [self setExecutedOperation:operation];
    [operation setAmountCurrency:self.amountCurrency];
    [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
        [self setExecutedOperation:nil];
        
        if (result) {
            [self.transferwisePayOutLabel setText:[NSString stringWithFormat:@"€ %@", result.transferwisePayOutString]];
            [self.transferwiseRateLabel setText:result.transferwiseRateString];
            [self.transferwiseTransferFeeLabel setText:[NSString stringWithFormat:@"€ %@", result.transferwiseTransferFeeString]];
            [self.bankPayOutLabel setText:[NSString stringWithFormat:@"£ %@", result.bankPayOutString]];
            [self.bankRateLabel setText:result.bankRateString];
            [self.bankTransferFeeLabel setText:[NSString stringWithFormat:@"£ %@", result.bankTransferFeeString]];
            self.title = [NSString stringWithFormat:@"Get € %@ more vs a bank", result.savedAmount];
            [self show];
        }

    }];
    
    [operation execute];
    
}

- (void)show
{
    TSAlertView *alert = [[TSAlertView alloc]initWithTitle:_title view:self delegate:nil cancelButtonTitle:@"Sounds cool" otherButtonTitles:nil];
    [alert show];
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
