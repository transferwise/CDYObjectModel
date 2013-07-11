
//
//  CreatePaymentOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CreatePaymentOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainPayment.h"
#import "PlainPaymentInput.h"

NSString *const kCreatePaymentPath = @"/payment/create";
NSString *const kValidatePaymentPath = @"/payment/validate";

@interface CreatePaymentOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) PlainPaymentInput *input;

@end

@implementation CreatePaymentOperation

- (id)initWithPath:(NSString *)path input:(PlainPaymentInput *)input {
    self = [super init];
    if (self) {
        _path = path;
        _input = input;
    }

    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:self.path];

    __block __weak CreatePaymentOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        PlainPayment *payment = [PlainPayment paymentWithData:response];
        weakSelf.responseHandler(payment, nil);
    }];

    [self postData:[self.input data] toPath:path];
}

+ (CreatePaymentOperation *)commitOperationWithPayment:(PlainPaymentInput *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kCreatePaymentPath input:input];
}

+ (CreatePaymentOperation *)validateOperationWithInput:(PlainPaymentInput *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kValidatePaymentPath input:input];
}

@end
