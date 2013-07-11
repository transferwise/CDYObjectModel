//
//  VerificationRequiredOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "VerificationRequiredOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainPaymentVerificationRequired.h"

NSString *const kVerificationRequiredPath = @"/verification/required";

@interface VerificationRequiredOperation ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation VerificationRequiredOperation

- (id)initWithData:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _data = dictionary;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kVerificationRequiredPath];

    __block __weak VerificationRequiredOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        PlainPaymentVerificationRequired *required = [[PlainPaymentVerificationRequired alloc] init];
        required.idVerificationRequired = [response[@"idVerification"] boolValue];
        required.addressVerificationRequired = [response[@"addressVerification"] boolValue];
        weakSelf.completionHandler(required, nil);
    }];

    [self getDataFromPath:path params:self.data];
}

+ (VerificationRequiredOperation *)operationWithData:(NSDictionary *)data {
    return [[VerificationRequiredOperation alloc] initWithData:data];
}

@end
