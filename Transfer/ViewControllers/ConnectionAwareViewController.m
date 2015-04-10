//
//  ConnectionAwareViewController.m
//  Transfer
//
//  Created by Mats Trovik on 27/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ConnectionAwareViewController.h"
#import <Reachability.h>
#import "Constants.h"
#import "GradientView.h"
#import "MOMStyle.h"

@interface ConnectionAwareViewController ()

@property (nonatomic, strong) UIViewController *wrappedViewController;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, weak) UIView *connectionAlert;
@property (nonatomic, strong) NSArray* clouds;
@property (nonatomic, assign) NSUInteger numberOfClouds;

@end

@implementation ConnectionAwareViewController

+(instancetype)createWrappedNavigationControllerWithRoot:(UIViewController*)rootController navBarHidden:(BOOL)hidden
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [navigationController setNavigationBarHidden:hidden];
    navigationController.navigationBar.translucent = NO;
    ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
    return wrapper;

}

- (id)initWithWrappedViewController:(UIViewController*)wrappedViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _wrappedViewController = wrappedViewController;
        _numberOfClouds = IPAD?7:4;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add contained viewcontroller's view
    
    [self replaceWrappedViewControllerWithController:self.wrappedViewController];
    
    
    NSURL* url = [NSURL URLWithString:TRWServerAddress];
    self.reachability = [Reachability reachabilityWithHostname:[url host]];
    __weak typeof(self) weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showConnectionAlert:NO];
        });
        
    };
    self.reachability.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showConnectionAlert:YES];
        });
    };
    
    [self.reachability startNotifier];

}

-(void) replaceWrappedViewControllerWithController:(UIViewController*)controller
{
    [self.wrappedViewController removeFromParentViewController];
    [self.wrappedViewController.view removeFromSuperview];
    self.wrappedViewController = controller;
    if(controller)
    {
        [controller willMoveToParentViewController:self];
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
        controller.view.frame = self.view.bounds;
        controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.wrappedViewController.view];
    }
}

-(void) replaceWrappedViewControllerWithController:(UIViewController*)controller withAnimationStyle:(ConnectionAwareAnimationStyle)animationStyle
{
    if(animationStyle == ConnectionModalAnimation)
    {
        [controller willMoveToParentViewController:self];
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
        CGRect newFrame = self.view.bounds;
        newFrame.origin.y = newFrame.size.height;
        controller.view.frame = newFrame;
        controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:controller.view];
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect endFrame = self.view.bounds;
            controller.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [self replaceWrappedViewControllerWithController:controller];
        }];
    }
    else
    {
        [self replaceWrappedViewControllerWithController:controller];
    }
}

-(void)animateCloud:(NSUInteger)index offset:(float)timeOffset
{
    if(self.clouds)
    {
        NSTimeInterval duration = (IPAD?40.0f:30.0f) + pow((3.3f),index);
        
        if(index < [self.clouds count])
        {
            UIView* cloud = self.clouds[index];
            CGRect startFrame = cloud.frame;
            startFrame.origin.x = ((self.connectionAlert.bounds.size.width + startFrame.size.width) * timeOffset ) - startFrame.size.width;
            startFrame.origin.y = 30.0f + roundf((self.connectionAlert.bounds.size.height - 40.0f)/self.numberOfClouds*index);
            cloud.frame = startFrame;
            [UIView animateWithDuration:duration - duration*timeOffset delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect endFrame = cloud.frame;
                endFrame.origin.x = self.connectionAlert.bounds.size.width;
                cloud.frame = endFrame;
            } completion:^(BOOL finished) {
                [self animateCloud:[self.clouds indexOfObject:cloud] offset:finished?0:1.0f - 0.9f * (arc4random()%100/100.0f)];
            }];
        }
    }
}

-(void)createAlert
{
    //Create Alert
    
    GradientView* gradientView = [[GradientView alloc] initWithFrame:CGRectMake(0,0,IPAD?1024:self.view.frame.size.width,74)];
    gradientView.orientation = OrientationVertical;
    gradientView.fromColor = [UIColor colorWithRed:174.0f/255.0f green:46.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    gradientView.toColor = [UIColor colorWithRed:221.0f/255.0f green:73.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    gradientView.clipsToBounds = YES;
    gradientView.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:gradientView];
    CGPoint center = gradientView.center;
    center.x = self.view.bounds.size.width/2.0f;
    gradientView.center = center;
    self.connectionAlert = gradientView;
    
    NSMutableArray* clouds = [NSMutableArray arrayWithCapacity:self.numberOfClouds];
    self.clouds = clouds;
    for(int i=0 ; i<self.numberOfClouds ;i++)
    {
        UIImageView* cloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cloud"]];
        if (i%2 == 0)
        {
            CGRect newFrame = cloud.frame;
            newFrame.size = CGSizeMake(newFrame.size.width/2.0f, newFrame.size.height/2.0f);
            cloud.frame = newFrame;
            cloud.alpha = 0.07;
        }
        else
        {
            cloud.alpha = 0.09;
        }
        [gradientView addSubview:cloud];
        [clouds addObject:cloud];
        float timeOffset = 1.0f - 0.9f * (arc4random()%100/100.0f);
        [self animateCloud:i offset:timeOffset];
    }
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(gradientView.bounds.size.width/2.0f - 150, 30, 300, 44)];
    title.textAlignment = NSTextAlignmentCenter;
    title.fontStyle = @"medium.@{18,19}.White";
    title.text = NSLocalizedString(@"network.alert",nil);
    [gradientView addSubview:title];

}

-(void)toggleAlert
{
    [self showConnectionAlert:!self.connectionAlert];
    
}

-(void)showConnectionAlert:(BOOL)shouldShow
{
    if(shouldShow)
    {
        if(!self.connectionAlert)
        {
            [self createAlert];
            CGRect startFrame = self.connectionAlert.frame;
            startFrame.origin.y = -startFrame.size.height;
            self.connectionAlert.frame = startFrame;
            [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:0 animations:^{
                CGRect startFrame = self.connectionAlert.frame;
                startFrame.origin.y = -10;
                self.connectionAlert.frame = startFrame;
            } completion:nil];
        }
    }
    else
    {
        UIView* disappearingView = self.connectionAlert;
        self.connectionAlert = nil;
        self.clouds = nil;
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect startFrame = disappearingView.frame;
            startFrame.origin.y = -startFrame.size.height;
            disappearingView.frame = startFrame;
        } completion:^(BOOL finished) {
            [disappearingView removeFromSuperview];
        }];
    }
}


@end
