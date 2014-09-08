//
//  SeparatorGreyButton.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "LightBlueButton.h"
#import "UIColor+MOMStyle.h"

@implementation LightBlueButton

-(void)commonSetup
{
	[super configureWithCompoundStyle:@"lightBlueButton"];
	
	self.layer.borderWidth = 1.f;
	self.layer.cornerRadius = 2.f;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [[UIColor colorFromStyle:@"SeparatorGrey"] CGColor];
}

@end
