//
//  UIButton+Skinning.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UIButton+Skinning.h"

@implementation UIButton (Skinning)

- (void)skinWithImage:(UIImage *)image insets:(UIEdgeInsets)insets {
    UIImage *skin = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:skin forState:UIControlStateNormal];
}

@end
