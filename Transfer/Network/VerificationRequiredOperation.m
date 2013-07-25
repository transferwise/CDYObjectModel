//
//  VerificationRequiredOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "VerificationRequiredOperation.h"
#import "TransferwiseOperation+Private.h"
#import "JCSObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "Currency.h"

NSString *const kVerificationRequiredPath = @"/verification/required";

@interface VerificationRequiredOperation ()

@end

@implementation VerificationRequiredOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kVerificationRequiredPath];

    __block __weak VerificationRequiredOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            PendingPayment *payment = [weakSelf.workModel pendingPayment];
            [payment setIdVerificationRequiredValue:[response[@"idVerification"] boolValue]];
            [payment setAddressVerificationRequiredValue:[response[@"addressVerification"] boolValue]];

            [weakSelf.workModel saveContext:^{
                weakSelf.completionHandler(nil);
            }];
        }];
    }];

    [self.workModel performBlock:^{
        PendingPayment *payment = [weakSelf.workModel pendingPayment];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"profile"] = [payment profileUsed];
        params[@"payIn"] = [payment payIn];
        params[@"sourceCurrency"] = [payment.sourceCurrency code];
        [self getDataFromPath:path params:params];
    }];
}

+ (VerificationRequiredOperation *)operation {
    return [[VerificationRequiredOperation alloc] init];
}

@end
