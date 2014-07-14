//
//  YahooButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "YahooButton.h"

@implementation YahooButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"YahooButton"
						  shadowColor:@"YahooShadow"
							imageName:@"Yahoo"];
	[super commonSetup];
}

@end
