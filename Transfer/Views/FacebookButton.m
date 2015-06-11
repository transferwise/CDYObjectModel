//
//  FacebookButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "FacebookButton.h"

@implementation FacebookButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"FacebookButton"
						  shadowColor:@"FacebookShadow"
							imageName:@"Facebook"];
	[super commonSetup];
}

@end
