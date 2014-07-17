//
//  GreyRoundedButton.m
//  Transfer
//
//  Created by Mats Trovik on 17/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "GrayRoundedButton.h"

@implementation GrayRoundedButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"greyRoundedButton"];
	[self setBackgroundImage:[UIImage imageNamed:@"Rounded"] forState:UIControlStateNormal];
	[super commonSetup];
}

@end
