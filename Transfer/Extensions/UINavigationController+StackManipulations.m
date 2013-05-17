//
//  UINavigationController+StackManipulations.m
//  Transfer
//
//  Created by Jaanus Siim on 5/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UINavigationController+StackManipulations.h"

@implementation UINavigationController (StackManipulations)

- (void)flattenStack {
    if ([self.viewControllers count] <= 2) {
        return;
    }

    NSArray *nextControllers = @[self.viewControllers[0], self.viewControllers.lastObject];
    [self setViewControllers:nextControllers];
}

@end
