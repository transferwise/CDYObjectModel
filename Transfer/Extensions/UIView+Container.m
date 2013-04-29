//
//  UIView+Container.m
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UIView+Container.h"

@implementation UIView (Container)

- (id)findContainerOfType:(Class)containerClass {
    UIView *checked = self;
    while ((checked = [checked superview]) != nil) {
        if ([checked isKindOfClass:containerClass]) {
            return checked;
        }
    }

    return nil;
}

@end
