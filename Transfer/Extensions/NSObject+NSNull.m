//
//  NSObject+NSNull.m
//  Transfer
//
//  Created by Juhan Hion on 19.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NSObject+NSNull.h"

@implementation NSObject (NSNull)

+ (id)getObjectOrNsNull:(id)object
{
	if (object)
	{
		return object;
	}
	
	return [NSNull null];
}

+ (id)getObjectOrNil:(id)object
{
	if (!object || object == [NSNull null])
	{
		return nil;
	}
	
	return object;
}

@end
