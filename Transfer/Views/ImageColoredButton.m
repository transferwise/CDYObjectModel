//
//  ImageColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ImageColoredButton.h"
#import "Constants.h"

@implementation ImageColoredButton

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor
						 imageName:(NSString *)imageName
{
	[super configureWithCompoundStyle:compoundStyle
						  shadowColor:shadowColor];
	
	[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	CGFloat left = (1 - (self.frame.size.width / 2));
	[self setImageEdgeInsets:UIEdgeInsetsMake(0, IPAD ? left : left + 20, 0, 0)];
	[self setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
	[super commonSetup];
}

@end
