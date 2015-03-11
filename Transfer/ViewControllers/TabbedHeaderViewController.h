//
//  TabbedHeaderViewController.h
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColoredButton;

@interface TabbedHeaderViewController : UIViewController

@property (nonatomic) BOOL showFullWidth;
@property (nonatomic) BOOL showButtonForIphone;
@property (nonatomic,weak) IBOutlet ColoredButton *actionButton;

- (void)configureWithControllers:(NSArray *)controllers
						  titles:(NSArray *)titles;

- (void)configureWithControllers:(NSArray *)controllers
						  titles:(NSArray *)titles
					 actionTitle:(NSString *)actionTitle
					 actionStyle:(NSString *)actionStyle
					actionShadow:(NSString *)actionShadow
				  actionProgress:(CGFloat)actionProgress;

- (void)willSelectViewController:(UIViewController *)controller
						 atIndex:(NSUInteger)index;

- (void)actionTappedWithController:(UIViewController *)controller
						   atIndex:(NSUInteger)index;

- (void)resetActionButtonTitle:(NSString *)title;


@end
