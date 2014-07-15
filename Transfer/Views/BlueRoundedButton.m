//
//  BlueRoundedButton.m
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BlueRoundedButton.h"

@implementation BlueRoundedButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"blueRoundedButton"];
	[self setBackgroundImage:[UIImage imageNamed:@"RoundedBlueButton"] forState:UIControlStateNormal];
	[self setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
	[super commonSetup];
}
@end
