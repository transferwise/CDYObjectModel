
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

NSString *const kCreatePaymentPath = @"/payment/create";

@interface CreatePaymentOperation ()

@property (nonatomic, strong) NSMutableDictionary *data;

@end

@implementation CreatePaymentOperation

- (id)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kCreatePaymentPath];

    __block __weak CreatePaymentOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        Payment *payment = [Payment paymentWithData:response];
        weakSelf.responseHandler(payment, nil);
    }];

    [self postData:self.data toPath:path];
}

+ (CreatePaymentOperation *)operation {
    return [[CreatePaymentOperation alloc] init];
}

- (void)setRecipientId:(NSNumber *)recipientId {
    self.data[@"recipientId"] = recipientId;
}

- (void)setSourceCurrency:(NSString *)sourceCurrency {
    self.data[@"sourceCurrency"] = sourceCurrency;
}

- (void)setTargetCurrency:(NSString *)targetCurrency {
    self.data[@"targetCurrency"] = targetCurrency;
}

- (void)setAmount:(NSString *)amount {
    self.data[@"amount"] = amount;
}

@end
