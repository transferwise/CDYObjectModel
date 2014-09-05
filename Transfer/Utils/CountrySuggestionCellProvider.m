//
//  CountrySuggestionCellProvider.m
//  Transfer
//
//  Created by Juhan Hion on 30.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CountrySuggestionCellProvider.h"
#import "Country.h"

@implementation CountrySuggestionCellProvider

-(void)refreshResults
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[self.autoCompleteResults.fetchedObjects count]];
    for(Country *country in self.autoCompleteResults.fetchedObjects)
    {
        if(country.name)
        {
            [result addObject:country.name];
        }
    }
	
    self.results = result;
}

- (Country *)getCountryByCode:(NSString *)code
{
	for(Country *country in self.autoCompleteResults.fetchedObjects)
    {
        if([country.iso3Code isEqualToString:code]
		   || [country.iso2Code isEqualToString:code]
		   || [[country.name lowercaseString] isEqualToString:[code lowercaseString]])
        {
            return country;
        }
    }
	
	return nil;
}

@end
