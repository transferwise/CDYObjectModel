//
//  MoneyCalculator.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyCalculator.h"
#import "MoneyEntryCell.h"
#import "Constants.h"
#import "CalculationResult.h"
#import "NSString+Validation.h"

@interface MoneyCalculator ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;
@property (nonatomic, copy) NSString *waitingAmount;
@property (nonatomic, copy) NSString *waitingSourceCurrency;
@property (nonatomic, copy) NSString *waitingTargetCurrency;

@end

@implementation MoneyCalculator

- (id)init {
    self = [super init];
    if (self) {
        [self setAmountCurrency:SourceCurrency];
    }

    return self;
}


- (void)setSendCell:(MoneyEntryCell *)sendCell {
    _sendCell = sendCell;

    [_sendCell.moneyField addTarget:self action:@selector(sendAmountChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setReceiveCell:(MoneyEntryCell *)receiveCell {
    _receiveCell = receiveCell;

    [_receiveCell.moneyField addTarget:self action:@selector(receiveAmountChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)sendAmountChanged:(UITextField *)field {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Send changed:%@", field.text);
        [self setAmountCurrency:SourceCurrency];
        [self setWaitingAmount:field.text];
        [self performCalculation];
    });
}

- (void)receiveAmountChanged:(UITextField *)field {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Receive changed:%@", field.text);
        [self setAmountCurrency:TargetCurrency];
        [self setWaitingAmount:field.text];
        [self performCalculation];
    });
}

- (void)forceCalculate {
    [self setWaitingAmount:[self.sendCell amount]];
    [self setWaitingSourceCurrency:[self.sendCell currency]];
    [self setWaitingTargetCurrency:[self.receiveCell currency]];

    [self performCalculation];
}

- (void)performCalculation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.executedOperation) {
            MCLog(@"Calculation running. Wait for it to finish");
            return;
        }

        NSString *amount = self.waitingAmount;
        NSString *sourceCurrency = self.waitingSourceCurrency;
        NSString *targetCurrency = self.waitingTargetCurrency;

        if (![amount hasValue]) {
            return;
        }

        TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:amount source:sourceCurrency target:targetCurrency];
        [self setExecutedOperation:operation];

        [operation setAmountCurrency:self.amountCurrency];

        [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
            [self setExecutedOperation:nil];

            if (result) {
                if (result.amountCurrency == SourceCurrency) {
                    [self.receiveCell.moneyField setText:result.transferwisePayOutString];
                } else {
                    [self.sendCell.moneyField setText:result.transferwisePayInString];
                }
            }

            self.calculationHandler(result, error);

            if (![amount isEqualToString:self.waitingAmount]
                    || ![sourceCurrency isEqualToString:self.waitingSourceCurrency]
                    || ![targetCurrency isEqualToString:self.waitingTargetCurrency]) {
                [self performCalculation];
            }
        }];

        [operation execute];
    });
}

@end
