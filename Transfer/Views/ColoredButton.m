//
//  ColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ColoredButton.h"
#import "UIFont+MOMStyle.h"
#import "UIColor+MOMStyle.h"
#import "UIImage+Color.h"

@implementation ColoredButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)configureWithTitleColor:(NSString *)titleColor
					 titleFont:(NSString *)titleFont
						 color:(NSString *)color
				highlightColor:(NSString *)highlightColor
{
	[self setTitleColor:[UIColor colorFromStyle:titleColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont fontFromStyle:titleFont]];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:color]] forState:UIControlStateNormal];
	[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:highlightColor]] forState:UIControlStateHighlighted];
    self.exclusiveTouch = YES;
}

@end
