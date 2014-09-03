//
//  UIViewController+SwitchToViewController.m
//  Transfer
//
//  Created by Juhan Hion on 03.09.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "UIViewController+SwitchToViewController.h"

@implementation UIViewController (SwitchToViewController)

- (void)switchToViewController:(UIViewController *)controller
{
	NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
	[viewControllers replaceObjectAtIndex:viewControllers.count -1 withObject:controller];
	[self.navigationController setViewControllers:viewControllers];
}

@end
