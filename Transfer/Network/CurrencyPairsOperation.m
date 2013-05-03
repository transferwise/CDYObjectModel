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

NSString *const kCurrencyPairsPath = @"/api/v1/public/currency/pairs";

@implementation CurrencyPairsOperation

- (void)execute {
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Cueency pairs error:%@", error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *pairs = response[@"pairs"];
        MCLog(@"Retrieved %d paris", [pairs count]);

    }];

    [self getDataFromPath:kCurrencyPairsPath];
}

+ (CurrencyPairsOperation *)pairsOperation {
    return [[CurrencyPairsOperation alloc] init];
}


@end
