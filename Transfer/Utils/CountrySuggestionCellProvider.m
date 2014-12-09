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
	
    self.results = self.autoCompleteResults.fetchedObjects;
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

- (void)refreshLookupWithCompletion:(void(^)(void))completionBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if([self.filterString length] > 0)
		{
			NSArray* filteredResults = [self getResultsFromArray:[self.results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Country *evaluatedObject, NSDictionary *bindings) {
				return evaluatedObject && [self isStartingWithNameOrCode:evaluatedObject
															  nameOrCode:self.filterString];
			}]]];
			
			filteredResults = [filteredResults sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
				return [obj1 caseInsensitiveCompare:obj2];
			}];
			
			self.dataSource = @[filteredResults];
		}
		else
		{
			self.dataSource = nil;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if(completionBlock)
			{
				completionBlock();
			}
		});
	});
}

- (NSArray *)getResultsFromArray:(NSArray *)array
{
	NSMutableArray* results = [NSMutableArray arrayWithCapacity:[array count]];
	for(Country *country in array)
	{
		if(country.name)
		{
			[results addObject:country.name];
		}
	}
	
	return [NSArray arrayWithArray:results];
}

//this differs from getCountryByCodeOrName in searching the containment of a string instead of equality
- (BOOL)isStartingWithNameOrCode:(Country *)country
					  nameOrCode:(NSString *)nameOrCode
{
	NSString* lowerCaseFilterString = [self.filterString lowercaseString];
	
	return [[country.name lowercaseString] rangeOfString:lowerCaseFilterString].location == 0
		|| [[country.iso3Code lowercaseString] rangeOfString:lowerCaseFilterString].location == 0;
}

@end
