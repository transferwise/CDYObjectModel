//
//  PaymentsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "JCSObjectModel.h"
#import "ObjectModel.h"
#import "ObjectModel+Payments.h"
#import "Payment.h"
#import "Constants.h"

NSString *const kPaymentsListPath = @"/payment/list";
NSUInteger kPaymentsListLimit = 20;

@interface PaymentsOperation ()

@property (nonatomic, assign) NSInteger offset;

@end

@implementation PaymentsOperation

- (id)initWithOffset:(NSInteger)offset {
    self = [super init];
    if (self) {
        _offset = offset;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kPaymentsListPath];

    __block __weak PaymentsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completion(0, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        //TODO jaanus: pull also recipient types here
        //TODO jaanus: put to sections
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSMutableArray *existingPaymentIds = [NSMutableArray arrayWithArray:[weakSelf.workModel listRemoteIdsForExistingPayments]];

            NSNumber *totalCount = response[@"total"];
            NSArray *payments = response[@"payments"];
            for (NSDictionary *data in payments) {
                Payment *payment = [weakSelf.workModel createOrUpdatePaymentWithData:data];
                [existingPaymentIds removeObject:payment.remoteId];
            }

            if (weakSelf.offset == 0) {
                MCLog(@"Have %d remote id's after zero pull", [existingPaymentIds count]);
                [weakSelf.workModel removePaymentsWithIds:existingPaymentIds];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.completion([totalCount integerValue], nil);
            }];
        }];
    }];

    [self getDataFromPath:path params:@{@"offset" : @(self.offset), @"limit" : @(kPaymentsListLimit)}];
}

+ (PaymentsOperation *)operationWithOffset:(NSInteger)offset {
    return [[PaymentsOperation alloc] initWithOffset:offset];
}

@end
