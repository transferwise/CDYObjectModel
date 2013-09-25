//
//  AppDelegate.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "ObjectModel.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "Constants.h"
#import "TestFlight.h"
#import "TransferwiseClient.h"
#import "ObjectModel+Users.h"
#import "GAI.h"
#import "SupportCoordinator.h"
#import "FeedbackCoordinator.h"
#import "UIColor+Theme.h"
#import "FBAppEvents.h"
#import "GoogleAnalytics.h"
#import "FBSettings.h"

@interface AppDelegate () <SWRevealViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (strong, nonatomic) SWRevealViewController *viewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (IOS_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if USE_TESTFLIGHT
    #if DEV_VERSION
        [TestFlight takeOff:@"78f288b9-67c6-4bd3-b6ba-bf9b54645412"];
    #else
        [TestFlight takeOff:@"4b176dca-177c-48bf-9480-a15001cc9211"];
    #endif
#endif

#if DEBUG
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#else
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#endif

    [[GAI sharedInstance] trackerWithTrackingId:TRWGoogleAnalyticsTrackingId];

    [Crashlytics startWithAPIKey:@"84bc4b5736898e3cfdb50d3d2c162c4f74480862"];

    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];

    if (IOS_7) {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar7.png"] forBarMetrics:UIBarMetricsDefault];
		[[UITabBar appearance] setTintColor:[UIColor transferWiseBlue]];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    }

    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UIImage *backButton = [[UIImage imageNamed:@"NavBarBackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];
    [model removeAnonymousUser];
    [model loadBaseData];

    [[TransferwiseClient sharedClient] setObjectModel:model];
    [[SupportCoordinator sharedInstance] setObjectModel:model];
    [[FeedbackCoordinator sharedInstance] setObjectModel:model];

    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];

    MainViewController *frontViewController = [[MainViewController alloc] init];
    [frontViewController setObjectModel:model];

    SettingsViewController *rearViewController = [[SettingsViewController alloc] init];
    [rearViewController setObjectModel:model];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearViewController frontViewController:frontViewController];
    
    mainRevealController.delegate = frontViewController;
    
	self.viewController = mainRevealController;
	
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[GoogleAnalytics sharedInstance] sendAppEvent:@"AppStarted"];
	[[GoogleAnalytics sharedInstance] markLoggedIn];

#if USE_FACEBOOK_EVENTS
    [FBSettings setDefaultAppID:@"274548709260402"];
    [FBAppEvents activateApp];
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.objectModel saveContext];
}

@end
