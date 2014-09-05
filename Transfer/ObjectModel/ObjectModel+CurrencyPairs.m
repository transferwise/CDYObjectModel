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

- (PairSourceCurrency *)pairSourceWithCurrency:(Currency *)currency {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currency = %@", currency];
    return [self fetchEntityNamed:[PairSourceCurrency entityName] withPredicate:predicate];
}

- (void)createOrUpdatePairWithData:(NSDictionary *)data index:(NSUInteger)index {
    NSString *currencyCode = data[@"currencyCode"];
    Currency *currency = [self currencyWithCode:currencyCode];
    PairSourceCurrency *source = [self pairSourceWithCurrency:currency];
    if (!source) {
        source = [PairSourceCurrency insertInManagedObjectContext:self.managedObjectContext];
        [source setCurrency:currency];
    }

    [source setHiddenValue:NO];
    [source setIndex:@(index)];
    [source setMaxInvoiceAmount:data[@"maxInvoiceAmount"]];
    NSArray *targets = data[@"targetCurrencies"];

    [self hideExistingTargetsForSource:source];

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

        [target setHiddenValue:NO];
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

- (NSFetchedResultsController *)fetchedControllerForSources {
    NSPredicate *notHidden = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self fetchedControllerForEntity:[PairSourceCurrency entityName] predicate:notHidden sortDescriptors:@[indexSortDescriptor]];
}

- (NSFetchedResultsController *)fetchedControllerForSourcesContainingTargetCurrency:(Currency *)currency {
    NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"ANY targets.currency = %@", currency];
    NSPredicate *notHidden = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notHidden, currencyPredicate]];
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self fetchedControllerForEntity:[PairSourceCurrency entityName] predicate:predicate sortDescriptors:@[indexSortDescriptor]];
}

- (NSFetchedResultsController *)fetchedControllerForTargetsWithSourceCurrency:(Currency *)currency {
    NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"source.currency = %@", currency];
    NSPredicate *notHidden = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notHidden, currencyPredicate]];
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self fetchedControllerForEntity:[PairTargetCurrency entityName] predicate:predicate sortDescriptors:@[indexSortDescriptor]];
}

- (PairTargetCurrency *)pairTargetWithSource:(Currency *)source target:(Currency *)target {
    NSPredicate *sourcePredicate = [NSPredicate predicateWithFormat:@"source.currency = %@", source];
    NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"currency = %@", target];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[sourcePredicate, targetPredicate]];
    return [self fetchEntityNamed:[PairTargetCurrency entityName] withPredicate:predicate];
}

- (void)hideExistingPairSources {
    NSArray *pairs = [self fetchEntitiesNamed:[PairSourceCurrency entityName] withPredicate:nil];
    for (PairSourceCurrency *sourceCurrency in pairs) {
        [sourceCurrency setHiddenValue:YES];
    }
}

- (void)hideExistingTargetsForSource:(PairSourceCurrency *)source {
    NSPredicate *sourcePredicate = [NSPredicate predicateWithFormat:@"source = %@", source];
    NSArray *targets = [self fetchEntitiesNamed:[PairTargetCurrency entityName] withPredicate:sourcePredicate];
    for (PairTargetCurrency *targetCurrency in targets) {
        [targetCurrency setHiddenValue:YES];
    }
}

@end
