//
//  TransferCalculationsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferCalculationsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "CalculationResult.h"

NSString *const kPaymentCalculationPath = @"/api/v1/public/payment/calculate";

@interface TransferCalculationsOperation ()

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;

@end

@implementation TransferCalculationsOperation

+ (TransferCalculationsOperation *)operationWithAmount:(NSString *)amount source:(NSString *)source target:(NSString *)target {
    TransferCalculationsOperation *operation = [[TransferCalculationsOperation alloc] init];
    [operation setAmount:amount];
    [operation setSourceCurrency:source];
    [operation setTargetCurrency:target];
    return operation;
}

- (void)execute {
    __block __weak TransferCalculationsOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        CalculationResult *result = [CalculationResult resultWithData:response];
        [result setSourceCurrency:weakSelf.sourceCurrency];
        [result setTargetCurrency:weakSelf.targetCurrency];
        weakSelf.remoteCalculationHandler(result, nil);
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.remoteCalculationHandler(nil, error);
    }];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"amount"] = self.amount;
    params[@"sourceCurrency"] = self.sourceCurrency;
    params[@"targetCurrency"] = self.targetCurrency;
    params[@"amountCurrency"] = @"source";
    [self getDataFromPath:kPaymentCalculationPath params:params];
}

@end
