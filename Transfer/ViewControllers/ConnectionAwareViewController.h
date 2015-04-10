//
//  ConnectionAwareViewController.h
//  Transfer
//
//  Created by Mats Trovik on 27/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

typedef NS_ENUM(short, ConnectionAwareAnimationStyle)
{
    ConnectionNoAnimation =0,
    ConnectionModalAnimation
};

#import <UIKit/UIKit.h>

@interface ConnectionAwareViewController : UIViewController

@property (nonatomic, readonly) UIViewController* wrappedViewController;

/**
 *  convenience method for making the supplied viewcontroller the root of a navigationcontroller, in its turn wrapped in a connection aware view controller.
 *
 *  @param rootController root controller
 *  @param hidden         set default value for hiding or showing nav bar.
 *
 *  @return ConnectionAwareViewController containing a navigation controller with the supplied viewcontroller as root.
 */
+(instancetype)createWrappedNavigationControllerWithRoot:(UIViewController*)rootController navBarHidden:(BOOL)hidden;

/**
 *  Initialise with a viewcontroller to contain.
 *
 *  @param wrappedViewController controller to contain
 *
 *  @return ConnectionAwareViewController containing the supplied viewcontroller
 */
- (id)initWithWrappedViewController:(UIViewController*)wrappedViewController;

/**
 *  replace the wrapped viewcontroller
 *
 *  @param controller new controller to wrap
 */
-(void) replaceWrappedViewControllerWithController:(UIViewController*)controller;

/**
 *  replace the wrapped viewcontroller with animation
 *
 *  @param controller new controller to wrap
 */
-(void) replaceWrappedViewControllerWithController:(UIViewController*)controller withAnimationStyle:(ConnectionAwareAnimationStyle)animationStyle;

@end
