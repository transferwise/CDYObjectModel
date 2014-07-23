//
//  FixSeparatorCell.m
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "FixSeparatorCell.h"

@implementation FixSeparatorCell

- (void)layoutSubviews
{
    [super layoutSubviews];
	
	//fixes the sometimes dissapearing separator view problem
	//hopefully Apple will fix it at one point.
    for (UIView *subview in self.contentView.superview.subviews)
	{
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"])
		{
            subview.hidden = NO;
        }
    }
}

@end
