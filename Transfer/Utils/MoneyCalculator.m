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
#import "TransferwiseOperation.h"
#import "TransferCalculationsOperation.h"

@interface MoneyCalculator ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation MoneyCalculator

- (void)setSendCell:(MoneyEntryCell *)sendCell {
    _sendCell = sendCell;

    [_sendCell.moneyField addTarget:self action:@selector(sendAmountChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setReceiveCell:(MoneyEntryCell *)receiveCell {
    _receiveCell = receiveCell;

    [_receiveCell.moneyField addTarget:self action:@selector(receiveAmountChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)receiveAmountChanged:(UITextField *)field {
    MCLog(@"Receive changed:%@", field);
}

- (void)sendAmountChanged:(UITextField *)field {
    MCLog(@"Send changed:%@", field);
}

- (void)forceCalculate {
    NSString *amount = [self.sendCell amount];
    NSString *sourceCurrency = [self.sendCell currency];
    NSString *targetCurrency = [self.receiveCell currency];

    TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:amount source:sourceCurrency target:targetCurrency];
    [self setExecutedOperation:operation];

    [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
        if (result) {
            [self.receiveCell.moneyField setText:[NSString stringWithFormat:@"%@", result.transferwisePayOut]];
        }
        self.calculationHandler(result, error);
    }];

    [operation execute];
}

@end
