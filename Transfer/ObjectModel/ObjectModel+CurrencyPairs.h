//
//  ObjectModel+CurrencyPairs.h
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class Currency;

@interface ObjectModel (CurrencyPairs)

- (BOOL)canMakePaymentToCurrency:(Currency *)currency;
- (void)createOrUpdatePairWithData:(NSDictionary *)data index:(NSUInteger)index;
- (NSFetchedResultsController *)fetchedControllerForSources;
- (NSFetchedResultsController *)fetchedControllerForSourcesContainingTargetCurrency:(Currency *)currency;
- (NSFetchedResultsController *)fetchedControllerForTargetsWithSourceCurrency:(Currency *)currency;

@end
