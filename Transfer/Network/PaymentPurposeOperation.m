//
//  PaymentPurposeOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 9/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentPurposeOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NetworkErrorCodes.h"

NSString *const kPaymentPurposePath = @"/verification/setPaymentsPurpose";

@interface PaymentPurposeOperation ()

@property (nonatomic, copy) NSString *purpose;
@property (nonatomic, copy) NSString *profile;

@end

@implementation PaymentPurposeOperation

- (id)initWithPurpose:(NSString *)purpose profile:(NSString *)profile {
    self = [super init];
    if (self) {
        [self setPurpose:purpose];
        [self setProfile:profile];
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kPaymentPurposePath];

    __block __weak PaymentPurposeOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSString *status = response[@"status"];
        if ([@"success" isEqualToString:status]) {
            weakSelf.resultHandler(nil);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:TRWErrorDomain code:ResponseServerError userInfo:@{}];
            weakSelf.resultHandler(error);
        }
    }];

    NSDictionary *data = @{@"profile" : self.profile, @"paymentsPurpose" : self.purpose};
    [self postData:data toPath:path];
}

+ (PaymentPurposeOperation *)operationWithPurpose:(NSString *)paymentPurpose forProfile:(NSString *)profile {
    return [[PaymentPurposeOperation alloc] initWithPurpose:paymentPurpose profile:profile];
}

@end
