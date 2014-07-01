//
//  ColoredButton.m
//  Transfer
//
//  Created by Juhan Hion on 18.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ColoredButton.h"
#import "MOMStyle.h"
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
    NSString *fontStyle;
	if (titleColor && titleFont)
	{
		fontStyle = [NSString stringWithFormat:@"%@.%@",titleFont,titleColor];
	}
    else
    {
        fontStyle = titleFont?:titleColor;
    }
	if (fontStyle)
	{
		self.fontStyle = fontStyle;
	}
	if (color != nil)
	{
		self.bgStyle = color;
	}
	if (highlightColor != nil)
	{
		self.highlightedBgStyle = highlightColor;
	}
    self.exclusiveTouch = YES;
}

@end
