//
//  NSMutableAttributedString+Presentation.h
//  Transfer
//
//  Created by Juhan Hion on 08.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Presentation)

- (void)setFont:(UIFont *)font
		toRange:(NSRange)range;

@end
