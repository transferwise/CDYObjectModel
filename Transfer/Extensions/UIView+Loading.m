//
//  UIView+Loading.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UIView+Loading.h"

@implementation UIView (Loading)

+ (id)loadInstance {
    NSString *expectedNibName = NSStringFromClass([self class]);
    return [UIView loadViewFromXib:expectedNibName];
}

+ (UIView *)loadViewFromXib:(NSString *)xibName {
    UIView *result = nil;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:[UIView class]]) {
            result = (UIView *) currentObject;
            break;
        }
    }

    return result;
}

@end
