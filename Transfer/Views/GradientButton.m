//
//  RedGradientButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "GradientButton.h"
#import "Constants.h"
#import "UIColor+MOMStyle.h"

@interface GradientButton ()

@property (strong, nonatomic) CAGradientLayer* gradientLayer;
@property (strong, nonatomic) CALayer* borderLayer;

@end

@implementation GradientButton

- (void)commonSetup
{
	[super configureWithCompoundStyle:@"redGradientButton"];
	[super commonSetup];
	
	[self setBackgroundColor:[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.1]];
	
	self.gradientLayer = [CAGradientLayer layer];
	[self.gradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
	[self.gradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [self updateGradient];
	
	[self.layer insertSublayer:self.gradientLayer atIndex:0];
}

-(void)updateGradient
{
    UIColor *fromColor = self.fromColor?:[UIColor whiteColor];
    UIColor *toColor = self.toColor?:[UIColor blackColor];
    [self.gradientLayer setColors:@[(id)fromColor.CGColor, (id)toColor.CGColor]];
}

-(void)setToColor:(UIColor *)toColor
{
    if (!(toColor == _toColor))
    {
        _toColor = toColor;
        [self updateGradient];
    }
}

-(void)setFromColor:(UIColor *)fromColor
{
    if (!(fromColor == _fromColor))
    {
        _fromColor = fromColor;
        [self updateGradient];
    }
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.gradientLayer setFrame:self.bounds];
}

@end
