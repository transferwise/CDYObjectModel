//
//  UITextField+ModifiedText.m
//  Transfer
//
//  Created by Juhan Hion on 28.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UITextField+ModifiedText.h"

@implementation UITextField (ModifiedText)

- (NSString *)modifiedText:(NSRange)range newText:(NSString *)text
{
	return [self.text stringByReplacingCharactersInRange:range withString:text];
}

@end
