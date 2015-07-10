//
//  LocationHelper.m
//  Transfer
//
//  Created by Juhan Hion on 12.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationHelper.h"
#import "ObjectModel+Currencies.h"
#import "Constants.h"
#import "ObjectModel+Users.h"
#import "BusinessProfile.h"
#import "PersonalProfile.h"
#import "User.h"

@implementation LocationHelper

+ (Currency *)getSourceCurrencyWithObjectModel:(ObjectModel *)objectModel
{
	if ([self isUS])
	{
		return [objectModel currencyWithCode:@"USD"];
	}
	else
	{
		//nil will be handled elswhere
		return nil;
	}
}

+ (NSString *)getSupportPhoneNumber
{
	if ([self isUS])
	{
		return TRWSupportCallNumberUS;
	}
	else
	{
		return TRWSupportCallNumber;
	}
}

+ (BOOL)isUS
{
	//you can have different actual languages used in US
	return [[NSLocale currentLocale].localeIdentifier hasSuffix:@"_US"];
}

+ (NSString *)getLanguage
{
	return [[NSBundle mainBundle] preferredLocalizations][0];
}


+ (NSString *)getSupportedLanguage
{
	NSString *lang = [self getLanguage];
	
	if ([@[@"fr", @"de", @"es", @"it"] containsObject:lang])
	{
		return lang;
	}
	
	//default to en
	return @"en";
}

+ (NSString *)getProfileLocationWithObjectModel:(ObjectModel *)objectModel
{
	NSString *profileCountry;
	
	//we are sending as business and there is a business profile
	if ([objectModel currentUser].sendAsBusinessDefaultSettingValue
		&& [objectModel currentUser].businessProfile)
	{
		profileCountry = [objectModel currentUser].businessProfile.countryCode;
	}
	else if([objectModel currentUser].personalProfile)
	{
		profileCountry = [objectModel currentUser].personalProfile.countryCode;
	}
	
	if (!profileCountry)
	{
		//this is a new user so no country in profile
		//determine from device settings
		profileCountry = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	}
	
	return profileCountry;
}

@end
