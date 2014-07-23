//
//  TabbedHeaderViewController.h
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbedHeaderViewController : UIViewController

@property (nonatomic, strong) UIViewController* firstViewController;
@property (nonatomic, strong) UIViewController* secondViewController;

- (void)configureWithFirstController:(UIViewController *)first
						  firstTitle:(NSString *)firstTitle
					secondController:(UIViewController *)second
						 secondTitle:(NSString *)secondTitle
						 actionTitle:(NSString *)actionTitle;

- (void)willSelectFirstViewController;
- (void)willSelectSecondViewController;
- (void)actionTapped;

@end
