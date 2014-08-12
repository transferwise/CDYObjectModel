
//
//  CreatePaymentOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CreatePaymentOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+RecipientTypes.h"
#import "Payment.h"
#import "ObjectModel+Payments.h"
#import "PendingPayment.h"

NSString *const kCreatePaymentPath = @"/payment/create";
NSString *const kValidatePaymentPath = @"/payment/validate";

@interface CreatePaymentOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSManagedObjectID *input;

@end

@implementation CreatePaymentOperation

- (id)initWithPath:(NSString *)path input:(NSManagedObjectID *)input {
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

    [self.workModel performBlock:^{
        PendingPayment *payment = (PendingPayment *) [self.workModel.managedObjectContext objectWithID:self.input];
		
        [self postData:[payment data] toPath:path];
    }];
}

+ (CreatePaymentOperation *)commitOperationWithPayment:(NSManagedObjectID *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kCreatePaymentPath input:input];
}

+ (CreatePaymentOperation *)validateOperationWithInput:(NSManagedObjectID *)input {
    return [[CreatePaymentOperation alloc] initWithPath:kValidatePaymentPath input:input];
}

@end
