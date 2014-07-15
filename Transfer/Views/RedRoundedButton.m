//
//  RedRoundedButton.m
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RedRoundedButton.h"

@implementation RedRoundedButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"redRoundedButton"];
	[self setBackgroundImage:[UIImage imageNamed:@"RoundedRedButton"] forState:UIControlStateNormal];
	[self setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
	[super commonSetup];
}


@end
