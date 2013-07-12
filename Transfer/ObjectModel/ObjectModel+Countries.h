//
//  ObjectModel+Countries.h
//  Transfer
//
//  Created by Jaanus Siim on 7/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@interface ObjectModel (Countries)

- (void)addOrCreateCountryWithData:(NSDictionary *)dictionary;
- (int)numberOfCountries;
- (NSFetchedResultsController *)fetchedControllerForAllCountries;

@end
