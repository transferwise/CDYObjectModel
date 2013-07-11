//
//  PaymentsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainPayment.h"

NSString *const kPaymentsListPath = @"/payment/list";

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
        weakSelf.completion(0, nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSNumber *totalCount = response[@"total"];
        NSArray *payments = response[@"payments"];
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[payments count]];
        for (NSDictionary *data in payments) {
            PlainPayment *payment = [PlainPayment paymentWithData:data];
            [result addObject:payment];
        }

        weakSelf.completion([totalCount integerValue], [NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path params:@{@"offset" : @(self.offset)}];
}

+ (PaymentsOperation *)operationWithOffset:(NSInteger)offset {
    return [[PaymentsOperation alloc] initWithOffset:offset];
}

@end
