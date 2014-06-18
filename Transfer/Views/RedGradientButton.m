//
//  RedGradientButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RedGradientButton.h"
#import "Constants.h"

@implementation RedGradientButton

-(void)commonSetup
{
	[super configureWithTitleColor:@"white" titleFont:IPAD ? @"medium.@14" : @"medium.@17" color:@"lightBlue3" highlightColor:@"blue"];
}

@end
