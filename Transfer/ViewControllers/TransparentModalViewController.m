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

@interface TransparentModalViewController ()

@property (nonatomic, weak) UIImageView* blurImageView;
@property (nonatomic, weak) UIView* blurEffectView;
@property (nonatomic, strong) UIViewController* hostViewController;

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
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = self.hostViewController.view.bounds;
        blurView.frame = self.hostViewController.view.bounds;
        
    } completion:nil];
}

-(void)animateSlideOut
{
    UIView *blurView = self.blurImageView?:self.blurEffectView;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.3f
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
    [UIView transitionWithView:self.hostViewController.view duration:0.3 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.hidden = NO;
        blurView.hidden = NO;
    } completion:nil];
}

-(void)animateFadeOut
{
    UIView *blurView = self.blurImageView?:self.blurEffectView;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView transitionWithView:self.hostViewController.view duration:0.3 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.view.hidden = YES;
        blurView.hidden = YES;
    } completion:^(BOOL finished) {
        [self dismissAnimationCompletionWithBlurview:blurView];
    }];
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




@end
