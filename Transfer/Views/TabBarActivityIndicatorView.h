//
//  TabBarActivityIndicatorView.h
//  Transfer
//
//  Created by Jaanus Siim on 7/1/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarActivityIndicatorView : UIView

- (void)setMessage:(NSString *)message;
- (void)hide;

+ (TabBarActivityIndicatorView *)showHUDOnController:(UIViewController *)controller;

@end
