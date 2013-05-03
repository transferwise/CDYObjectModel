//
//  CurrenciesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrenciesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "Currency.h"

NSString *const kCurrencyListPath = @"/currency/list";

@implementation CurrenciesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kCurrencyListPath];

    __block __weak CurrenciesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *currencies = response[@"currencies"];
        MCLog(@"Pulled %d currencies", [currencies count]);

        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[currencies count]];
        for (NSDictionary *data in currencies) {
            Currency *currency = [Currency currencyWithRecipientData:data];
            [result addObject:currency];
        }

        weakSelf.resultHandler([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path];
}

+ (CurrenciesOperation *)operation {
    return [[CurrenciesOperation alloc] init];
}

@end
