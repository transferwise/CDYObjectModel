//
//  ObjectModel+Currencies.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Currencies.h"
#import "Currency.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"

@implementation ObjectModel (Currencies)

- (Currency *)currencyWithCode:(NSString *)code {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code = %@", code];
    Currency *result = [self fetchEntityNamed:[Currency entityName] withPredicate:predicate];

    if (!result) {
        NSUInteger index = [self countInstancesOfEntity:[Currency entityName]];
        result = [Currency insertInManagedObjectContext:self.managedObjectContext];
        [result setCode:code];
        [result setIndex:@(index)];
    }

    return result;
}

- (void)createOrUpdateCurrencyWithData:(NSDictionary *)data index:(NSUInteger)index {
    NSString *code = data[@"code"];
    Currency *currency = [self currencyWithCode:code];
    [currency setSymbol:data[@"symbol"]];
    [currency setName:data[@"name"]];
    [currency setDefaultRecipientType:[self recipientTypeWithCode:data[@"defaultRecipientType"]]];
	//REMOVE WHEN API IS READY
	NSNumber* paymentReferenceMaxLength = [NSNumber numberWithInt:5];
	if(data[@"paymentReferenceMaxLength"])
	{
		paymentReferenceMaxLength = (NSNumber *)data[@"paymentReferenceMaxLength"];
	}
	[currency setReferenceMaxLength:paymentReferenceMaxLength];
	
    NSArray *allTypes = data[@"recipientTypes"];
    NSArray *typeObjects = [self recipientTypesWithCodes:allTypes];

    NSArray *orderedTypes = [typeObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        RecipientType *one = obj1;
        RecipientType *two = obj2;

        NSNumber *oneIndex = @([allTypes indexOfObject:one.type]);
        NSNumber *twoIndex = @([allTypes indexOfObject:two.type]);

        return [oneIndex compare:twoIndex];
    }];

    [currency setRecipientTypes:[[NSOrderedSet alloc] initWithArray:orderedTypes]];
    [currency setIndexValue:(int16_t) index];
}

- (NSFetchedResultsController *)fetchedControllerForAllCurrencies {
    NSSortDescriptor *indexSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    return [self fetchedControllerForEntity:[Currency entityName] sortDescriptors:@[indexSortDescriptor]];
}

@end
