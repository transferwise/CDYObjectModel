//
//  StateSuggestionProvider.m
//  Transfer
//
//  Created by Mats Trovik on 26/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "StateSuggestionCellProvider.h"

//TODO: remove when state is available from api
@implementation State

@end

@interface StateSuggestionCellProvider ()

@end

@implementation StateSuggestionCellProvider

+(NSDictionary*)stateLookup
{
	return @{@"AL": @"Alabama",
			 @"AK": @"Alaska",
			 @"AZ": @"Arizona",
			 @"AR": @"Arkansas",
			 @"CA": @"California",
			 @"CO": @"Colorado",
			 @"CT": @"Connecticut",
			 @"DE": @"Delaware",
			 @"DC": @"District Of Columbia",
			 @"FL": @"Florida",
			 @"GA": @"Georgia",
			 @"HI": @"Hawaii",
			 @"ID": @"Idaho",
			 @"IL": @"Illinois",
			 @"IN": @"Indiana",
			 @"IA": @"Iowa",
			 @"KS": @"Kansas",
			 @"KY": @"Kentucky",
			 @"LA": @"Louisiana",
			 @"ME": @"Maine",
			 @"MD": @"Maryland",
			 @"MA": @"Massachusetts",
			 @"MI": @"Michigan",
			 @"MN": @"Minnesota",
			 @"MS": @"Mississippi",
			 @"MO": @"Missouri",
			 @"MT": @"Montana",
			 @"NE": @"Nebraska",
			 @"NV": @"Nevada",
			 @"NH": @"New Hampshire",
			 @"NJ": @"New Jersey",
			 @"NM": @"New Mexico",
			 @"NY": @"New York",
			 @"NC": @"North Carolina",
			 @"ND": @"North Dakota",
			 @"OH": @"Ohio",
			 @"OK": @"Oklahoma",
			 @"OR": @"Oregon",
			 @"PA": @"Pennsylvania",
			 @"RI": @"Rhode Island",
			 @"SC": @"South Carolina",
			 @"SD": @"South Dakota",
			 @"TN": @"Tennessee",
			 @"TX": @"Texas",
			 @"UT": @"Utah",
			 @"VT": @"Vermont",
			 @"VA": @"Virginia",
			 @"WA": @"Washington",
			 @"WV": @"West Virginia",
			 @"WI": @"Wisconsin",
			 @"WY": @"Wyoming"};
}

- (id)init
{
	self = [super init];
	if(self)
	{
		self.results = [[[[self class] stateLookup] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	}
	return self;
}

- (State *)stateFromTitle:(NSString*)title
{
	NSDictionary* stateLookup = [StateSuggestionCellProvider stateLookup];
	title = [[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] capitalizedString];
	NSArray* codes = [stateLookup allKeysForObject:title];
	
	if (codes && codes.count > 0)
	{
		State *s = [self getState:title code:[codes firstObject]];
		return s;
	}
	
	return nil;
}

- (State *)getByCodeOrName:(NSString*)codeOrName
{
	NSString* title = [StateSuggestionCellProvider stateLookup][[codeOrName uppercaseString]];
	
	if (title)
	{
		State *s = [self getState:title code:codeOrName];
		return s;
	}
	else
	{
		return [self stateFromTitle:codeOrName];
	}
}

- (State *)getState:(NSString *)title code:(NSString *)code
{
	State *state = [[State alloc] init];
	state.name = title;
	state.code = code;
	return state;
}

@end
