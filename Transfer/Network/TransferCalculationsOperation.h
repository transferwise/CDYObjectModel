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

@interface TransferCalculationsOperation : TransferwiseOperation

@property (nonatomic, copy) TWRemoteCalculationHandler remoteCalculationHandler;

+ (TransferCalculationsOperation *)operationWithAmount:(NSString *)amount source:(NSString *)source target:(NSString *)target;

@end
