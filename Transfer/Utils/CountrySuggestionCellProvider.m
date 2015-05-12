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
	NSString *lowerCoderOrName = [codeOrName lowercaseString];
	for(Country *country in self.autoCompleteResults.fetchedObjects)
    {
		if([[country.iso3Code lowercaseString] isEqualToString:lowerCoderOrName]
		   || [[country.iso2Code lowercaseString] isEqualToString:lowerCoderOrName]
		   || [[country.name lowercaseString] isEqualToString:lowerCoderOrName])
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
			NSMutableArray* filteredResults = [[self getResultsFromArray:[self.results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Country *evaluatedObject, NSDictionary *bindings) {
				return evaluatedObject && [self isStartingWithNameOrCode:evaluatedObject
															  nameOrCode:self.filterString];
			}]]]mutableCopy];
			
            [filteredResults sortUsingSelector:@selector(caseInsensitiveCompare:)];

            
            NSArray* finalResults = [filteredResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH[c] %@",self.filterString]];
            [filteredResults removeObjectsInArray:finalResults];
            finalResults = [finalResults arrayByAddingObjectsFromArray:filteredResults];
			
			self.dataSource = @[finalResults];
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
		|| [[country.iso3Code lowercaseString] rangeOfString:lowerCaseFilterString].location == 0
		|| [[country.iso2Code lowercaseString] rangeOfString:lowerCaseFilterString].location == 0;
}

@end
