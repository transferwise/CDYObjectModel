//
//  TransparentModalViewController.m
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"
#import "UIView+RenderBlur.h"
#import "MOMStyle.h"

#define kInOutAnimationduration 0.3f
#define kCommonAnimationduration 0.2f

@interface TransparentModalViewController ()

@property (nonatomic, weak) UIImageView* blurImageView;
@property (nonatomic, weak) UIView* blurEffectView;
@property (nonatomic, weak) UIViewController* hostViewController;

@end

@implementation TransparentModalViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if(self.view.bgStyle && [UIVisualEffectView class])
    {
        self.view.bgStyle = [self.view.bgStyle stringByAppendingString:@".iOS8alpha"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.blurImageView.hidden = YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self redrawBlurView];
}


-(void)presentOnViewController:(UIViewController*)hostViewcontroller
{
    [self presentOnViewController:hostViewcontroller withPresentationStyle:self.presentationStyle];
}

-(void)presentOnViewController:(UIViewController*)hostViewcontroller withPresentationStyle:(TransparentModalPresentationStyle)presentationStyle;
{
    self.presentationStyle = presentationStyle;
    self.hostViewController= hostViewcontroller;
    [self willMoveToParentViewController:hostViewcontroller];
    [self.hostViewController addChildViewController:self];
    [self didMoveToParentViewController:self.hostViewController];
    
    UIView *blurView;
    if ([UIVisualEffectView class])
    {
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.blurEffectView=blurEffectView;
        blurView = blurEffectView;
    }
    else
    {
        UIImageView *blurredimage = [[UIImageView alloc] initWithFrame:hostViewcontroller.view.frame];
        self.blurImageView = blurredimage;
        [self redrawBlurView];
        blurView = blurredimage;
        blurredimage.contentMode = UIViewContentModeBottom;
        blurredimage.clipsToBounds = YES;
        
    }
    [hostViewcontroller.view addSubview:self.view];
    [hostViewcontroller.view insertSubview:blurView belowSubview:self.view];
    blurView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    for(UIView* slideView in self.slideInAnimationViews)
    {
        slideView.hidden = YES;
    }
    for(UIView* fadeView in self.fadeInAnimationViews)
    {
        fadeView.hidden = YES;
    }
    
    switch (presentationStyle) {
        case TransparentPresentationFade:
            [self animateFadeIn];
            break;
        case TransparentPresentationSlide:
        default:
            [self animateSlideIn];
            break;
    }
    
    [self didMoveToParentViewController:self.hostViewController];
    
}

-(IBAction)dismiss
{
    switch (self.presentationStyle) {
        case TransparentPresentationFade:
            [self animateFadeOut];
            break;
        case TransparentPresentationSlide:
        default:
            [self animateSlideOut];
            break;
    }
}

-(void)redrawBlurView
{
    if(self.blurImageView)
    {
        self.view.hidden = YES;
        self.blurImageView.hidden = YES;
        self.blurImageView.image = [self.hostViewController.view renderBlurWithTintColor:[UIColor clearColor]];
        self.view.hidden = NO;
        self.blurImageView.hidden = NO;
    }
}

#pragma mark - presentation styles
-(void)animateSlideIn
{
    UIView* blurView = self.blurEffectView?:self.blurImageView;
    CGRect newFrame = self.hostViewController.view.bounds;
    newFrame.origin.y = newFrame.size.height;
    self.view.frame = newFrame;
    newFrame.size.height = 0.0f;
    blurView.frame=newFrame;
    [UIView animateWithDuration:kInOutAnimationduration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = self.hostViewController.view.bounds;
        blurView.frame = self.hostViewController.view.bounds;
        
    } completion:^(BOOL finished) {
        [self commonPresentationAnimation];
    }];
}

-(void)animateSlideOut
{
    UIView *blurView = self.blurImageView?:self.blurEffectView;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:kInOutAnimationduration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect newFrame = self.view.bounds;
                         newFrame.origin.y = newFrame.size.height;
                         self.view.frame = newFrame;
                         if(blurView == self.blurImageView)
                         {
                             newFrame.size.height = 0.0f;
                         }
                         blurView.frame = newFrame;
                     }
                     completion:^(BOOL finished) {
                         [self dismissAnimationCompletionWithBlurview:blurView];
                     }];
}

-(void)animateFadeIn
{
    UIView* blurView = self.blurEffectView?:self.blurImageView;
    CGRect newFrame = self.hostViewController.view.bounds;
    self.view.frame = newFrame;
    blurView.frame=newFrame;
    self.view.hidden = YES;
    blurView.hidden = YES;
    [UIView transitionWithView:self.hostViewController.view duration:kInOutAnimationduration options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.hidden = NO;
        blurView.hidden = NO;
    } completion:^(BOOL finished) {
        [self commonPresentationAnimation];
    }];
}

-(void)animateFadeOut
{
    UIView *blurView = self.blurImageView?:self.blurEffectView;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView transitionWithView:self.hostViewController.view duration:kInOutAnimationduration options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.hidden = YES;
        blurView.hidden = YES;
    } completion:^(BOOL finished) {
        [self dismissAnimationCompletionWithBlurview:blurView];
    }];
}

-(void)commonPresentationAnimation
{
    NSUInteger slidingAnimationsCount = MIN([self.slideInAnimationViews count],[self.slideInAnimationConstraints count]);
    NSMutableArray* postAnimationConstraintConstants = [NSMutableArray arrayWithCapacity:slidingAnimationsCount];
    for (int i = 0; i< slidingAnimationsCount; i++)
    {
        NSLayoutConstraint *constraint = self.slideInAnimationConstraints[i];
        UIView *view = self.slideInAnimationViews[i];
        [postAnimationConstraintConstants addObject:@(constraint.constant)];
        constraint.constant = (constraint.constant >= 0 ? -1 : 1) * view.bounds.size.width;
        NSLog(@"%@",constraint.description);
        view.hidden = NO;
        [view layoutIfNeeded];
    }
    
    for (UIView *view in self.fadeInAnimationViews)
    {
        view.alpha = 0.0f;
        view.hidden = NO;
    }
    
    [UIView animateWithDuration:kCommonAnimationduration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UIView *view in self.fadeInAnimationViews)
        {
            view.alpha = 1.0f;
        }
        for(int i = 0; i < [postAnimationConstraintConstants count]; i++)
        {
            NSLayoutConstraint *constraint = self.slideInAnimationConstraints[i];
            UIView *view = self.slideInAnimationViews[i];
            constraint.constant = [postAnimationConstraintConstants[i] floatValue];
            [view layoutIfNeeded];
        }
    } completion:nil];
    
}

-(void)dismissAnimationCompletionWithBlurview:(UIView*)blurView
{
    [self.view removeFromSuperview];
    [blurView removeFromSuperview];
    [self removeFromParentViewController];
    if ([self.delegate respondsToSelector:@selector(dismissCompleted:)])
    {
        [self.delegate dismissCompleted:self];
    }
}

-(UIViewController*)hostViewController
{
    return _hostViewController;
}

@end
