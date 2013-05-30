
//
//  CreatePaymentOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CreatePaymentOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Payment.h"
#import "PaymentInput.h"

NSString *const kCreatePaymentPath = @"/payment/create";
NSString *const kValidatePaymentPath = @"/payment/validate";

@interface CreatePaymentOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) PaymentInput *input;

@end

@implementation CreatePaymentOperation

- (id)initWithPath:(NSString *)path input:(PaymentInput *)input {
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
        Payment *payment = [Payment paymentWithData:response];
        weakSelf.responseHandler(payment, nil);
    }];

    [self postData:[self.input data] toPath:path];
}

+ (CreatePaymentOperation *)commitOperationWithPayment:(PaymentInput *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kCreatePaymentPath input:input];
}

+ (CreatePaymentOperation *)validateOperationWithInput:(PaymentInput *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kValidatePaymentPath input:input];
}

@end
