//
//  UIGestureRecognizer+Cancel.m
//  Transfer
//
//  Created by Juhan Hion on 07.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIGestureRecognizer+Cancel.h"

@implementation UIGestureRecognizer (Cancel)

- (void)cancel
{
	self.enabled = NO;
	self.enabled = YES;
}

@end
