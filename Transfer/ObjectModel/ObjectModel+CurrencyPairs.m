//
//  ObjectModel+CurrencyPairs.m
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+CurrencyPairs.h"
#import "CurrencyPair.h"

@implementation ObjectModel (CurrencyPairs)

- (NSArray *)listAllCurrencyPairs {
    return [self listEntitiesNamed:[CurrencyPair entityName]];
}

- (void)addPairWithData:(NSDictionary *)data {
    NSString *source = data[@"source"];
    NSString *target = data[@"target"];

    //TODO jaanus: check that no existing pair present?
    CurrencyPair *pair = [CurrencyPair insertInManagedObjectContext:self.managedObjectContext];
    [pair setSource:source];
    [pair setTarget:target];
}

- (CurrencyPair *)defaultPair {
    NSString *defaultSource = @"EUR";
    NSString *defaultTarget = @"GBP";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source = %@ AND target = %@", defaultSource, defaultTarget];
    CurrencyPair *pair = [self findEntityNamed:[CurrencyPair entityName] withPredicate:predicate];
    if (pair) {
        return pair;
    }

    [self addPairWithData:@{@"source" : defaultSource, @"target" : defaultTarget}];
    [self saveContext];
    return [self defaultPair];
}

@end
