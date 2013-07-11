//
//  ObjectModel+Currencies.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Currencies.h"
#import "Currency.h"

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

@end
