//
//  ImageColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ImageColoredButton.h"

@implementation ImageColoredButton

- (void)configureWithCompoundStyle:(NSString *)compoundStyle
					   shadowColor:(NSString *)shadowColor
						 imageName:(NSString *)imageName
{
	[super configureWithCompoundStyle:compoundStyle
						  shadowColor:shadowColor];
	[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
	[super commonSetup];
	
}

@end
