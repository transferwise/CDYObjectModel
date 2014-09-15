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

- (Country *)getCountryByCodeOrName:(NSString *)codeOrName
{
	for(Country *country in self.autoCompleteResults.fetchedObjects)
    {
        if([country.iso3Code isEqualToString:codeOrName]
		   || [country.iso2Code isEqualToString:codeOrName]
		   || [[country.name lowercaseString] isEqualToString:[codeOrName lowercaseString]])
        {
            return country;
        }
    }
	
	return nil;
}

@end
