//
//  PaymentsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Payment.h"

NSString *const kPaymentsListPath = @"/payment/list";

@implementation PaymentsOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kPaymentsListPath];

    __block __weak PaymentsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completion(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *payments = response[@"payments"];
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[payments count]];
        for (NSDictionary *data in payments) {
            Payment *payment = [Payment paymentWithData:data];
            [result addObject:payment];
        }

        weakSelf.completion([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path];
}

@end
