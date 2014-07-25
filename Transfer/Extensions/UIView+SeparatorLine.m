//
//  UIView+UIView_SeparatorLine.m
//  Transfer
//
//  Created by Juhan Hion on 24.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIView+SeparatorLine.h"
#import "UIView+MOMStyle.h"

@implementation UIView (SeparatorLine)

+ (UIView *)getSeparatorLineWithParentFrame:(CGRect)parentFrame
{
	CGFloat lineThickness = 1.0f / [[UIScreen mainScreen] scale];
	UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(parentFrame.origin.x + 10.0f, parentFrame.size.height - lineThickness, parentFrame.size.width - 15.0f, lineThickness)];
	separatorLine.bgStyle = @"SeparatorGrey";
	separatorLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	return separatorLine;
}

@end
