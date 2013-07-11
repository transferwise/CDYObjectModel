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
#import "ObjectModel+Currencies.h"
#import "PairTargetCurrency.h"

@implementation ObjectModel (CurrencyPairs)

- (BOOL)canMakePaymentToCurrency:(Currency *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY targets.currency = %@", currency];

    return [self countInstancesOfEntity:[PairSourceCurrency entityName] withPredicate:predicate] > 0;
}

- (PairSourceCurrency *)sourceWithCurrency:(Currency *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currency = %@", currency];
    return [self fetchEntityNamed:[PairSourceCurrency entityName] withPredicate:predicate];
}

- (void)createOrUpdatePairWithData:(NSDictionary *)data index:(NSUInteger)index {
    NSString *currencyCode = data[@"currencyCode"];
    Currency *currency = [self currencyWithCode:currencyCode];
    PairSourceCurrency *source = [self sourceWithCurrency:currency];
    if (!source) {
        source = [PairSourceCurrency insertInManagedObjectContext:self.managedObjectContext];
        [source setCurrency:currency];
    }

    [source setIndex:@(index)];
    [source setMaxInvoiceAmount:data[@"maxInvoiceAmount"]];
    NSArray *targets = data[@"targetCurrencies"];

    NSUInteger targetIndex = 0;
    for (NSDictionary *targetData in targets) {
        NSString *targetCode = targetData[@"currencyCode"];
        Currency *targetCurrency = [self currencyWithCode:targetCode];
        PairTargetCurrency *target = [self existingTargetForSource:source withCurrency:targetCurrency];
        if (!target) {
            target = [PairTargetCurrency insertInManagedObjectContext:self.managedObjectContext];
            [target setCurrency:targetCurrency];
            [target setSource:source];
        }

        [target setMinInvoiceAmount:targetData[@"minInvoiceAmount"]];
        [target setFixedTargetPaymentAllowed:targetData[@"fixedTargetPaymentAllowed"]];
        [target setIndex:@(targetIndex++)];
    }
}

- (PairTargetCurrency *)existingTargetForSource:(PairSourceCurrency *)source withCurrency:(Currency *)currency {
    NSPredicate *sourcePredicate = [NSPredicate predicateWithFormat:@"source = %@", source];
    NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"currency = %@", currency];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[sourcePredicate, currencyPredicate]];
    return [self fetchEntityNamed:[PairTargetCurrency entityName] withPredicate:predicate];
}

@end
