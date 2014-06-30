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

@interface ConnectionAwareViewController ()

@property (nonatomic, weak) UIViewController *wrappedViewController;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, weak) UIView *connectionAlert;

@end

@implementation ConnectionAwareViewController

- (id)initWithWrappedViewController:(UIViewController*)wrappedViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self addChildViewController:wrappedViewController];
        _wrappedViewController = wrappedViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add contained viewcontroller's view
    
    self.wrappedViewController.view.frame = self.view.bounds;
    self.wrappedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.wrappedViewController.view];
    
    //Create Alert
    
    GradientView* gradientView = [[GradientView alloc] initWithFrame:CGRectMake(0,0,IPAD?1024:320,64)];
    gradientView.orientation = OrientationVertical;
    gradientView.fromColor = [UIColor colorWithRed:91.0f/255.0f green:130.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
    gradientView.toColor = [UIColor colorWithRed:83.0f/255.0f green:124.0f/255.0f blue:155.0f/255.0f alpha:1.0f];
    [self.view addSubview:gradientView];
    self.connectionAlert = gradientView;

    self.reachability = [Reachability reachabilityWithHostname:TRWServerAddress];
    __weak typeof(self) weakSelf = self;
    self.reachability.reachableBlock = ^(Reachability*reach)
    {
        [weakSelf showConnectionAlert:(YES)];
    };
    self.reachability.unreachableBlock = ^(Reachability*reach)
    {
        [weakSelf showConnectionAlert:(NO)];
    };

}

-(void)showConnectionAlert:(BOOL)shouldShow
{
    
}



@end
