//
//  ObjectModel+Countries.m
//  Transfer
//
//  Created by Jaanus Siim on 7/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Countries.h"
#import "Country.h"

@implementation ObjectModel (Countries)


- (Country *)countryWithIso3Code:(NSString *)iso3Code {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iso3Code = %@", iso3Code];
    return [self fetchEntityNamed:[Country entityName] withPredicate:predicate];
}

- (void)addOrCreateCountryWithData:(NSDictionary *)data {
    NSString *iso3Code = data[@"iso3Code"];
    Country *country = [self countryWithIso3Code:iso3Code];
    if (!country) {
        country = [Country insertInManagedObjectContext:self.managedObjectContext];
        [country setIso3Code:iso3Code];
    }

    [country setIso2Code:data[@"iso2Code"]];
    [country setName:data[@"name"]];
}

- (NSInteger)numberOfCountries {
    return [self countInstancesOfEntity:[Country entityName]];
}

- (NSFetchedResultsController *)fetchedControllerForAllCountries {
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    return [self fetchedControllerForEntity:[Country entityName] sortDescriptors:@[nameDescriptor]];
}

@end
