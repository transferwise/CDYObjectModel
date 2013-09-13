//
//  UIColor+Theme.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UIColor+Theme.h"
#import "Constants.h"

@implementation UIColor (Theme)

+ (UIColor *)controllerBackgroundColor {
    return [UIColor colorWithWhite:0.949 alpha:1.000];
}

+ (UIColor *)mainTextColor {
    return [UIColor colorWithRed:0.435 green:0.467 blue:0.529 alpha:1.000];
}

+ (UIColor *)settingsBackgroundColor {
    return [UIColor colorWithRed:0.196 green:0.227 blue:0.263 alpha:1.000];
}

+ (UIColor *)disabledEntryTextColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)transferWiseBlue {
    return HEXCOLOR(0x003B5AFF);
}

@end
