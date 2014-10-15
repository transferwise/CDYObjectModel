//
//  MoneyCalculator.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyCalculator.h"
#import "MoneyEntryCell.h"
#import "CalculationResult.h"
#import "NSString+Validation.h"
#import "Currency.h"
#import "ObjectModel.h"
#import "ObjectModel+CurrencyPairs.h"
#import "GoogleAnalytics.h"
#import "PairTargetCurrency.h"

@interface MoneyCalculator ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, copy) NSString *waitingAmount;
@property (nonatomic, strong) Currency *waitingSourceCurrency;
@property (nonatomic, strong) Currency *waitingTargetCurrency;

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
    __weak typeof(self) weakSelf = self;
    [sendCell setCurrencyChangedHandler:^(Currency *currency) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Currency1Selected" withLabel:currency.code];
        [weakSelf sourceCurrencyChanged:currency];
    }];
}

- (void)setReceiveCell:(MoneyEntryCell *)receiveCell {
    _receiveCell = receiveCell;

    [_receiveCell.moneyField addTarget:self action:@selector(receiveAmountChanged:) forControlEvents:UIControlEventEditingChanged];
    __weak typeof(self) weakSelf = self;
    [receiveCell setCurrencyChangedHandler:^(Currency *currency) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Currency2Selected" withLabel:currency.code];
        [weakSelf setWaitingTargetCurrency:currency];
        [weakSelf enforceFixedTargetAllowedRule];
        [weakSelf performCalculation];
    }];
}

- (void)sendAmountChanged:(UITextField *)field {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Send changed:%@", field.text);
        [self setAmountCurrency:SourceCurrency];
        [self setWaitingAmount:[field.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self performCalculation];
    });
}

- (void)receiveAmountChanged:(UITextField *)field {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Receive changed:%@", field.text);
        [self setAmountCurrency:TargetCurrency];
        [self setWaitingAmount:[field.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        [self performCalculation];
    });
}

- (void)sourceCurrencyChanged:(Currency *)currency {
    MCLog(@"sourceCurrencyChanged");
    [self setWaitingSourceCurrency:currency];
    [self.receiveCell setCurrencies:[self.objectModel fetchedControllerForTargetsWithSourceCurrency:currency]];
    [self setWaitingTargetCurrency:[self.receiveCell currency]];

    [self enforceFixedTargetAllowedRule];
    
    [self performCalculation];
}

- (void)forceCalculate {
    [self setWaitingAmount:(self.amountCurrency == SourceCurrency ? [self.sendCell amount] : [self.receiveCell amount]) ];

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
            self.activityHandler(NO);
            return;
        }

        self.activityHandler(YES);

        TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:amount source:sourceCurrency target:targetCurrency];
        [self setExecutedOperation:operation];

        [operation setAmountCurrency:self.amountCurrency];
        __weak typeof(self) weakSelf = self;
        [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setExecutedOperation:nil];
                if (result) {
                    if (result.amountCurrency == SourceCurrency) {
                        [weakSelf.receiveCell setMoneyValue:result.transferwisePayOutString];
                    } else {
                        [weakSelf.sendCell.moneyField setText:result.transferwisePayInString];
                    }
                }

                self.calculationHandler(result, error);
                self.activityHandler(NO);

                if (![amount isEqualToString:self.waitingAmount]
                        || ![sourceCurrency isEqualToString:self.waitingSourceCurrency.code]
                        || ![targetCurrency isEqualToString:self.waitingTargetCurrency.code]) {
                    [weakSelf performCalculation];
                }
            });
        }];

        [operation execute];
    });
}

-(void)enforceFixedTargetAllowedRule
{
    PairTargetCurrency* target = [self.objectModel pairTargetWithSource:self.waitingSourceCurrency target:self.waitingTargetCurrency];
    if(!target.fixedTargetPaymentAllowedValue && self.amountCurrency == TargetCurrency)
    {
        [self setWaitingAmount:[self.sendCell amount]];
        self.amountCurrency = SourceCurrency;
    }
}

@end
