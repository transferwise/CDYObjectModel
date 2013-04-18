//
//  TransferCalculationsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@class CalculationResult;

typedef void (^TWRemoteCalculationHandler)(CalculationResult *result, NSError *error);

typedef NS_ENUM(short, CalculationAmountCurrency) {
    SourceCurrency,
    TargetCurrency
};

@interface TransferCalculationsOperation : TransferwiseOperation

@property (nonatomic, copy) TWRemoteCalculationHandler remoteCalculationHandler;
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;

+ (TransferCalculationsOperation *)operationWithAmount:(NSString *)amount source:(NSString *)source target:(NSString *)target;

@end
