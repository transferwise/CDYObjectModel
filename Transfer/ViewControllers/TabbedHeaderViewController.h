//
//  TabbedHeaderViewController.h
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbedHeaderViewController : UIViewController

@property (nonatomic) BOOL showFullWidth;

- (void)configureWithControllers:(NSArray *)controllers
						  titles:(NSArray *)titles
					 actionTitle:(NSString *)actionTitle
					 actionStyle:(NSString *)actionStyle
				  actionProgress:(CGFloat)actionProgress;

- (void)willSelectViewController:(UIViewController *)controller
						 atIndex:(NSUInteger)index;

- (void)actionTappedWithController:(UIViewController *)controller
						   atIndex:(NSUInteger)index;

- (void)resetActionButtonTitle:(NSString *)title;


@end
