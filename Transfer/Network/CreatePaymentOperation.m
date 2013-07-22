
//
//  CreatePaymentOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CreatePaymentOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainPaymentInput.h"
#import "JCSObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "Payment.h"
#import "ObjectModel+Payments.h"

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
        [weakSelf.workModel.managedObjectContext performBlock:^{
            Payment *payment;
            if (![response[@"status"] isEqualToString:@"valid"]) {
                //must be actual payment create response
                payment = [weakSelf.workModel createOrUpdatePaymentWithData:response];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.responseHandler(payment.objectID, nil);
            }];
        }];
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
