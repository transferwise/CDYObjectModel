//
//  GoogleButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "GoogleButton.h"

@implementation GoogleButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"RedButton"
						  shadowColor:@"RedShadow"
							imageName:@"Google"];
	[super commonSetup];
}

@end
