//
//  TransparentModalViewController.m
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"
#import "UIView+RenderBlur.h"

@interface TransparentModalViewController ()

@property (nonatomic, weak) UIImageView* blurView;
@property (nonatomic, weak) UIViewController* hostViewController;

@end

@implementation TransparentModalViewController

-(void)viewDidLoad
{
	[super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.blurView.hidden = YES;
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
    UIImageView *blurredimage = [[UIImageView alloc] initWithFrame:hostViewcontroller.view.frame];
    self.blurView = blurredimage;
    [self redrawBlurView];
    [hostViewcontroller.view insertSubview:blurredimage belowSubview:self.view];
    blurredimage.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    blurredimage.contentMode = UIViewContentModeBottom;
    blurredimage.clipsToBounds = YES;
    self.view.frame = newFrame;
    newFrame.size.height = 0.0f;
    blurredimage.frame=newFrame;
    [self didMoveToParentViewController:hostViewcontroller];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.frame = hostViewcontroller.view.bounds;
        self.blurView.frame = hostViewcontroller.view.bounds;
        
    } completion:nil];
}

-(void)redrawBlurView
{
    self.view.hidden = YES;
    self.blurView.hidden = YES;
    self.blurView.image = [self.hostViewController.view renderBlurWithTintColor:[UIColor clearColor]];
    self.view.hidden = NO;
    self.blurView.hidden = NO;
}

-(IBAction)dismiss
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect newFrame = self.view.bounds;
        newFrame.origin.y = newFrame.size.height;
        self.view.frame = newFrame;
        newFrame.size.height = 0.0f;
        self.blurView.frame = newFrame;
    }completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self.blurView removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end
