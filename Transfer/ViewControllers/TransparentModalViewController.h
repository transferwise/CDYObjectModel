//
//  TransparentModalViewController.h
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransparentModalViewController;

typedef NS_ENUM(short, TransparentModalPresentationStyle)
{
    TransparentPresentationSlide = 0,
    TransparentPresentationFade
};

@protocol TransparentModalViewControllerDelegate <NSObject>

@optional

-(void)dismissCompleted:(TransparentModalViewController*) dismissedController;

@end

@interface TransparentModalViewController : UIViewController

@property (nonatomic, weak) id<TransparentModalViewControllerDelegate> delegate;
@property (nonatomic, assign) TransparentModalPresentationStyle presentationStyle;

/**
 *  Array of views to slide in horizontally when the modal is presented
 */
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray* slideInAnimationViews;
/**
 *  Array of horisontal layout constraints relative to the superview's edge used to slide in views horizontally. 
 *  The constraints must match up with the slideInAnimationViews array
 */
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray* slideInAnimationConstraints;

/**
 *  Array of views to fade in when the modal is presented
 */
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray* fadeInAnimationViews;

-(void)presentOnViewController:(UIViewController*)hostViewcontroller withPresentationStyle:(TransparentModalPresentationStyle)presentationStyle;
-(void)presentOnViewController:(UIViewController*)hostViewcontroller;
-(IBAction)dismiss;
-(UIViewController*)hostViewController;

@end
