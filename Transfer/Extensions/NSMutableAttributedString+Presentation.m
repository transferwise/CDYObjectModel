//
//  NSMutableAttributedString+Presentation.m
//  Transfer
//
//  Created by Juhan Hion on 08.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NSMutableAttributedString+Presentation.h"

@implementation NSMutableAttributedString (Presentation)

- (void)setFont:(UIFont *)font
		toRange:(NSRange)range
{
	[self addAttribute:NSFontAttributeName
				 value:font
				 range:range];
}

@end
