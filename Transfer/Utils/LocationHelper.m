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

@implementation LocationHelper

+ (Currency *)getSourceCurrencyWithObjectModel:(ObjectModel *)objectModel
{
	if ([[NSLocale currentLocale].localeIdentifier isEqualToString:@"en_US"])
	{
		return [objectModel currencyWithCode:@"USD"];
	}
	else
	{
		//nil will be handled elswhere
		return nil;
	}
}

@end
