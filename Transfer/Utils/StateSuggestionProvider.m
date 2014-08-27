//
//  StateSuggestionProvider.m
//  Transfer
//
//  Created by Mats Trovik on 26/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "StateSuggestionProvider.h"

@interface StateSuggestionProvider ()

@end

@implementation StateSuggestionProvider

+(NSDictionary*)stateLookup
{
   return @{@"AL": @"Alabama",
                        @"AK": @"Alaska",
                        @"AS": @"American Samoa",
                        @"AZ": @"Arizona",
                        @"AR": @"Arkansas",
                        @"CA": @"California",
                        @"CO": @"Colorado",
                        @"CT": @"Connecticut",
                        @"DE": @"Delaware",
                        @"DC": @"District Of Columbia",
                        @"FM": @"Federated States Of Micronesia",
                        @"FL": @"Florida",
                        @"GA": @"Georgia",
                        @"GU": @"Guam",
                        @"HI": @"Hawaii",
                        @"ID": @"Idaho",
                        @"IL": @"Illinois",
                        @"IN": @"Indiana",
                        @"IA": @"Iowa",
                        @"KS": @"Kansas",
                        @"KY": @"Kentucky",
                        @"LA": @"Louisiana",
                        @"ME": @"Maine",
                        @"MH": @"Marshall Islands",
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
                        @"MP": @"Northern Mariana Islands",
                        @"OH": @"Ohio",
                        @"OK": @"Oklahoma",
                        @"OR": @"Oregon",
                        @"PW": @"Palau",
                        @"PA": @"Pennsylvania",
                        @"PR": @"Puerto Rico",
                        @"RI": @"Rhode Island",
                        @"SC": @"South Carolina",
                        @"SD": @"South Dakota",
                        @"TN": @"Tennessee",
                        @"TX": @"Texas",
                        @"UT": @"Utah",
                        @"VT": @"Vermont",
                        @"VI": @"Virgin Islands",
                        @"VA": @"Virginia",
                        @"WA": @"Washington",
                        @"WV": @"West Virginia",
                        @"WI": @"Wisconsin",
                        @"WY": @"Wyoming"};
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.results = [[[[self class] stateLookup] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return self;
}

+(NSString*)stateCodeFromTitle:(NSString*)title
{
    NSDictionary* stateLookup = [self stateLookup];
    title = [[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]capitalizedString];
    NSArray* codes = [stateLookup allKeysForObject:title];
    return [codes firstObject];
}

+(NSString*)titleFromStateCode:(NSString*)code
{
    return [self stateLookup][[code uppercaseString]];
}

@end
