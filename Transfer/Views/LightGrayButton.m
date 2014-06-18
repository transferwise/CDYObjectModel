//
//  LightGrayButton.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "LightGrayButton.h"
#import "UIColor+MOMStyle.h"

@implementation LightGrayButton

-(void)commonSetup
{
	[super configureWithTitleColor:@"navBarBlue"
						 titleFont:@"medium.@17"
							 color:@"blue"
					highlightColor:@"cellSelected"];
	
	self.layer.borderWidth = 1.f;
	self.layer.cornerRadius = 2.f;
	self.layer.masksToBounds = YES;
	self.layer.borderColor = [[UIColor colorFromStyle:@"lightGray"] CGColor];
}

@end
