//
//  TargetCountryProvider.m
//  Transfer
//
//  Created by Juhan Hion on 09.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TargetCountryProvider.h"
#import "Currency.h"
#import "Constants.h"

@implementation TargetCountryProvider

+ (NSDictionary *)countryMapping
{
	DEFINE_SHARED_INSTANCE_USING_BLOCK((^{
		return @{
				 @"gbp" : @"uk",
				 @"usd"	: @"usa",
				 @"pln"	: @"pol",
				 @"sel"	: @"swe",
				 @"dkk" : @"dnk",
				 @"nok" : @"nor",
				 @"chf" : @"che",
				 @"cad" : @"can",
				 @"aud" : @"aus",
				 @"huf" : @"hun",
				 @"gel" : @"geo",
				 @"try" : @"tur",
				 @"ron" : @"rou",
				 @"sgd" : @"sgp",
				 @"nzd" : @"nzl",
				 @"inr" : @"ind",
				 @"hkd" : @"hkg",
				 @"czk" : @"cze",
				 @"bgn" : @"bgr",
				 @"myr" : @"mys",
				 @"php" : @"phl",
				 @"thb" : @"tha",
				 @"aed" : @"are",
				 @"cny" : @"chn",
				 @"cop" : @"col",
				 @"brl" : @"bra",
				 @"mex" : @"mex",
				 @"ngn" : @"nga",
				 @"pkr" : @"pak",
				 };
	}));
	
}

+ (NSString *)getTargetCountryForCurrency:(Currency *)currency
{
	NSString* lowerCaseCode = [currency.code lowercaseString];
	
	if (currency && self.countryMapping[lowerCaseCode])
	{
		return self.countryMapping[lowerCaseCode];
	}
	
	return nil;
}

@end
