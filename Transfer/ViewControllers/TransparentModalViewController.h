//
//  TransparentModalViewController.h
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransparentModalViewControllerDelegate <NSObject>

@optional
- (void)modalClosed;

@end

@interface TransparentModalViewController : UIViewController

@property (nonatomic, weak) id<TransparentModalViewControllerDelegate> delegate;
@property (nonatomic, readonly) UIViewController* hostViewController;

-(void)presentOnViewController:(UIViewController*)hostViewcontroller;
-(IBAction)dismiss;

@end
