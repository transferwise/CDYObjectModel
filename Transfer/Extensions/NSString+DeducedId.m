//
//  NSString+DeducedId.m
//  Transfer
//
//  Created by Juhan Hion on 15.06.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "NSString+DeducedId.h"

@implementation NSString (DeducedId)

- (NSInteger)deducedId
{
	return [[self substringFromIndex:1] integerValue] - 10000;
}

@end
