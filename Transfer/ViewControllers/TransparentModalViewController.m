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
    self.hostViewController= hostViewcontroller;
    [self willMoveToParentViewController:hostViewcontroller];
    [hostViewcontroller addChildViewController:self];
    [hostViewcontroller.view addSubview:self.view];
    CGRect newFrame = hostViewcontroller.view.bounds;
    newFrame.origin.y = newFrame.size.height;
    UIView *blurView;
    if ([UIVisualEffectView class])
    {
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        [hostViewcontroller.view insertSubview:blurEffectView belowSubview:self.view];
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.blurEffectView=blurEffectView;
        blurView = blurEffectView;
    }
    else
    {
        UIImageView *blurredimage = [[UIImageView alloc] initWithFrame:hostViewcontroller.view.frame];
        self.blurImageView = blurredimage;
        [self redrawBlurView];
        [hostViewcontroller.view insertSubview:blurredimage belowSubview:self.view];
        blurView = blurredimage;
        blurredimage.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        blurredimage.contentMode = UIViewContentModeBottom;
        blurredimage.clipsToBounds = YES;
    }
    self.view.frame = newFrame;
    newFrame.size.height = 0.0f;
    blurView.frame=newFrame;
    [self didMoveToParentViewController:hostViewcontroller];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = hostViewcontroller.view.bounds;
       blurView.frame = hostViewcontroller.view.bounds;
        
    } completion:nil];
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

-(IBAction)dismiss
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
						 [self.view removeFromSuperview];
						 [blurView removeFromSuperview];
						 [self removeFromParentViewController];
						 if ([self.delegate respondsToSelector:@selector(modalClosed)])
						 {
							 [self.delegate modalClosed];
						 }
					 }];
}

-(UIViewController*)hostViewController
{
    return _hostViewController;
}
@end
