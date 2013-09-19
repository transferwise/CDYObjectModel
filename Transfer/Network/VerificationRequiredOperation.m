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
#import "NSDictionary+Cleanup.h"
#import "Constants.h"

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

    [self setOperationSuccessHandler:^(NSDictionary *rawResponse) {
        [weakSelf.workModel performBlock:^{
            NSDictionary *response = [rawResponse dictionaryByRemovingNullObjects];
            PendingPayment *payment = [weakSelf.workModel pendingPayment];
			IdentificationRequired identificationRequired = IdentificationNoneRequired;
			if ([response[@"idVerification"] boolValue]) {
				identificationRequired = identificationRequired | IdentificationIdRequired;
			}
			if ([response[@"addressVerification"] boolValue]) {
				identificationRequired = identificationRequired | IdentificationAddressRequired;
			}
			if ([response[@"paymentsPurposeVerification"] boolValue]) {
				identificationRequired = identificationRequired | IdentificationPaymentPurposeRequired;
			}
            [payment setVerificiationNeededValue:identificationRequired];
            [payment setProposedPaymentsPurpose:response[@"proposedPaymentsPurpose"]];

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
