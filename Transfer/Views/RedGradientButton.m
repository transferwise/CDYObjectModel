//
//  RedGradientButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RedGradientButton.h"
#import "Constants.h"
#import "UIColor+MOMStyle.h"

@interface RedGradientButton ()

@property (strong, nonatomic) CAGradientLayer* gradientLayer;
@property (strong, nonatomic) CALayer* borderLayer;

@end

@implementation RedGradientButton

- (void)commonSetup
{
	[super configureWithTitleColor:@"white" titleFont:IPAD ? @"medium.@14" : @"medium.@17" color:nil highlightColor:@"blue"];
	
	[self setBackgroundColor:[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.1]];
	
	self.gradientLayer = [CAGradientLayer layer];
	[self.gradientLayer setColors:[NSArray arrayWithObjects:
					  (id)[UIColor colorFromStyle:@"RedShadow"].CGColor,
					  (id)[UIColor colorFromStyle:@"Red"].CGColor,
					  nil]];
	[self.gradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
	[self.gradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
	
	[self.layer insertSublayer:self.gradientLayer atIndex:0];
	
	self.borderLayer = [CALayer layer];
	self.borderLayer.borderColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.1].CGColor;
	self.borderLayer.borderWidth = 3;
	
	[self.layer addSublayer:self.borderLayer];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.gradientLayer setFrame:self.bounds];
	[self.borderLayer setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 3, self.bounds.size.height)];
}

@end
