//
//  WhiteRoundedButton.m
//  Transfer
//
//  Created by Mats Trovik on 05/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "WhiteRoundedButton.h"

@implementation WhiteRoundedButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"whiteRoundedButton"];
	[self setBackgroundImage:[UIImage imageNamed:@"RoundedWhiteButton"] forState:UIControlStateNormal];
	[super commonSetup];
}

@end
