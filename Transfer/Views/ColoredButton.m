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
		[self commonSetup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
	[self commonSetup];
}

- (void)commonSetup
{
	//override in an inheriting class to customize
}

-(void)configureWithTitleColor:(NSString *)titleColor
					 titleFont:(NSString *)titleFont
						 color:(NSString *)color
				highlightColor:(NSString *)highlightColor
{
	if (titleColor != nil)
	{
		[self setTitleColor:[UIColor colorFromStyle:titleColor] forState:UIControlStateNormal];
		
	}
	if (titleColor != nil)
	{
		[self.titleLabel setFont:[UIFont fontFromStyle:titleFont]];
	}
	if (color != nil)
	{
		[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:color]] forState:UIControlStateNormal];
	}
	if (highlightColor != nil)
	{
		[self setBackgroundImage:[UIImage imageFromColor:[UIColor colorFromStyle:highlightColor]] forState:UIControlStateHighlighted];
	}
    self.exclusiveTouch = YES;
}

@end