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
#import "PlainCurrency.h"

@interface MoneyCalculator ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;
@property (nonatomic, copy) NSString *waitingAmount;
@property (nonatomic, strong) PlainCurrency *waitingSourceCurrency;
@property (nonatomic, strong) PlainCurrency *waitingTargetCurrency;

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
    [sendCell setCurrencyChangedHandler:^(PlainCurrency *currency) {
        [self sourceCurrencyChanged:currency];
    }];
}

- (void)setReceiveCell:(MoneyEntryCell *)receiveCell {
    _receiveCell = receiveCell;

    [_receiveCell.moneyField addTarget:self action:@selector(receiveAmountChanged:) forControlEvents:UIControlEventEditingChanged];
    [receiveCell setCurrencyChangedHandler:^(PlainCurrency *currency) {
        [self setWaitingTargetCurrency:currency];
        [self performCalculation];
    }];
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

- (void)setCurrencies:(NSArray *)currencies {
    _currencies = currencies;

    [self.sendCell setPresentedCurrencies:currencies];
    PlainCurrency *selected = currencies[0];
    [self sourceCurrencyChanged:selected];
}

- (void)sourceCurrencyChanged:(PlainCurrency *)currency {
    [self setWaitingSourceCurrency:currency];
    NSArray *targets = currency.targets;
    [self.receiveCell setPresentedCurrencies:targets];
    [self setWaitingTargetCurrency:targets[0]];

    [self performCalculation];
}

- (void)forceCalculate {
    [self setWaitingAmount:[self.sendCell amount]];

    [self performCalculation];
}

- (void)performCalculation {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.executedOperation) {
            MCLog(@"Calculation running. Wait for it to finish");
            return;
        }

        NSString *amount = self.waitingAmount;
        NSString *sourceCurrency = self.waitingSourceCurrency.code;
        NSString *targetCurrency = self.waitingTargetCurrency.code;

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
                    || ![sourceCurrency isEqualToString:self.waitingSourceCurrency.code]
                    || ![targetCurrency isEqualToString:self.waitingTargetCurrency.code]) {
                [self performCalculation];
            }
        }];

        [operation execute];
    });
}

@end
