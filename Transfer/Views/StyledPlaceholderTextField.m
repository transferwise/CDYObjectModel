//
//  StyledPlaceholderTextField.m
//  Transfer
//
//  Created by Juhan Hion on 25.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "StyledPlaceholderTextField.h"

@interface StyledPlaceholderTextField ()

@end

@implementation StyledPlaceholderTextField

- (void)drawPlaceholderInRect:(CGRect)rect
{
	
    // We use self.font.pointSize in order to match the input text's font size
	rect = CGRectInset(rect, 0, (rect.size.height - self.font.lineHeight) / 2.0);
    [self.placeholder drawInRect:rect
                  withAttributes:@{NSForegroundColorAttributeName:[self.placeholderStyle color],
								   NSFontAttributeName:[self.placeholderStyle font]}];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
    self.placeholder=title;
    [self setText:value];
}

@end
