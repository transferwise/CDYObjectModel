//
//  ObjectModel+CurrencyPairs.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+CurrencyPairs.h"
#import "Currency.h"
#import "PairSourceCurrency.h"

@implementation ObjectModel (CurrencyPairs)

- (BOOL)canMakePaymentToCurrency:(Currency *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY targets.currency = %@", currency];

    return [self countInstancesOfEntity:[PairSourceCurrency entityName] withPredicate:predicate] > 0;
}

@end
