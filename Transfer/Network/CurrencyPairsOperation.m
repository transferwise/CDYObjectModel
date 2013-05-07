//
//  CurrencyPairsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/19/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrencyPairsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "Currency.h"

NSString *const kCurrencyPairsPath = @"/api/v1/public/currency/pairs";

@implementation CurrencyPairsOperation

- (void)execute {
    __block __weak CurrencyPairsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Cueency pairs error:%@", error);
        weakSelf.currenciesHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *pairs = response[@"sourceCurrencies"];
        MCLog(@"Retrieved %d paris", [pairs count]);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[pairs count]];
        for (NSDictionary *data in pairs) {
            Currency *currency = [Currency currencyWithSourceData:data];
            [result addObject:currency];
        }

        weakSelf.currenciesHandler([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:kCurrencyPairsPath];
}

+ (CurrencyPairsOperation *)pairsOperation {
    return [[CurrencyPairsOperation alloc] init];
}


@end
