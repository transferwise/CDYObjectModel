//
//  GradientView.m
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GradientView

+(Class)layerClass
{
    return [CAGradientLayer class];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self commonSetup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self commonSetup];
}

-(void)commonSetup
{
    self.orientation = OrientationHorizontal;
    [self updateColor];
}

-(void)setOrientation:(enum GradientOrientation)orientation
{
    _orientation = orientation;
    self.gradient.startPoint = orientation == OrientationHorizontal?CGPointMake(0.0f, 0.5f):CGPointMake(0.5f, 0.0f);
    self.gradient.endPoint = orientation == OrientationHorizontal?CGPointMake(1.0f, 0.5f):CGPointMake(0.5f, 1.0f);
}

-(void)setFromColor:(UIColor *)fromColor
{
    _fromColor = fromColor;
    [self updateColor];
}

-(void)setToColor:(UIColor *)toColor
{
    _toColor = toColor;
    [self updateColor];
}

-(void)updateColor
{
    self.gradient.colors = [NSArray arrayWithObjects:(id)[self.fromColor?:[UIColor clearColor]CGColor], (id)[self.toColor?:[UIColor colorWithWhite:0.0f alpha:0.12f] CGColor], nil];
}

-(CAGradientLayer*)gradient
{
    return (CAGradientLayer*)self.layer;
}

@end
