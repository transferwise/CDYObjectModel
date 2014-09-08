//
//  NSString+iPadLocalization.m
//  Transfer
//
//  Created by Juhan Hion on 06.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NSString+DeviceSpecificLocalisation.h"
#import "Constants.h"

@implementation NSString (DeviceSpecificLocalization)

- (NSString*)deviceSpecificLocalization
{
	if (IPAD)
	{
		return [NSString stringWithFormat:@"%@.%@", self, @"ipad"];
	}
	
	return self;
}

@end
