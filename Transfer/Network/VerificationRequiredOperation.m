//
//  VerificationRequiredOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "VerificationRequiredOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PaymentVerificationRequired.h"

NSString *const kVerificationRequiredPath = @"/verification/required";

@implementation VerificationRequiredOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kVerificationRequiredPath];

    __block __weak VerificationRequiredOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        PaymentVerificationRequired *required = [[PaymentVerificationRequired alloc] init];
        required.idVerificationRequired = [response[@"idVerification"] boolValue];
        required.addressVerificationRequired = [response[@"addressVerification"] boolValue];
        weakSelf.completionHandler(required, nil);
    }];

    [self getDataFromPath:path];
}

@end
