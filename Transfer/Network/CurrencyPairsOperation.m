//
//  CurrencyPairsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/19/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrencyPairsOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kCurrencyPairsPath = @"/api/v1/public/currency/pairs";

@implementation CurrencyPairsOperation

- (void)execute {
    [self getDataFromPath:kCurrencyPairsPath];
}

@end
