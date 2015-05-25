//
//  NSString+NullString.m
//  Transfer
//
//  Created by Juhan Hion on 04.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "NSString+NullString.h"

@implementation NSString (NullString)

- (NSString *)getNullOnNullAsValue
{
	if ([[self lowercaseString] isEqualToString:@"null"])
	{
		return nil;
	}
	else
	{
		return self;
	}
}

@end
