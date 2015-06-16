//
//  BlueRoundedButton.m
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BlueRoundedSolidWhiteButton.h"

@implementation BlueRoundedSolidWhiteButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"blueRoundedButton"];
	[self setBackgroundImage:[UIImage imageNamed:@"RoundedBlueSolidWhiteButton"] forState:UIControlStateNormal];
	[super commonSetup];
}
@end
