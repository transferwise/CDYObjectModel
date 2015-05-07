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
	return [[self localeIdentifier] hasSuffix:@"_US"];
}

+ (NSString *)getLanguage
{
	NSString* localeIdentifier = [self localeIdentifier];
	
	return [localeIdentifier substringToIndex:2];
}

+ (NSString *)localeIdentifier
{
	NSLocale *currentLocale = [NSLocale currentLocale];
	
	return currentLocale.localeIdentifier;
}

@end
