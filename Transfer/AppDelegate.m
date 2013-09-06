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

@interface AppDelegate () <SWRevealViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (strong, nonatomic) SWRevealViewController *viewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if USE_TESTFLIGHT
    #if DEV_VERSION
        [TestFlight takeOff:@"78f288b9-67c6-4bd3-b6ba-bf9b54645412"];
    #else
        [TestFlight takeOff:@"4b176dca-177c-48bf-9480-a15001cc9211"];
    #endif
#endif

#if DEBUG
    [[GAI sharedInstance] setDebug:YES];
#endif

    [[GAI sharedInstance] trackerWithTrackingId:TRWGoogleAnalyticsTrackingId];

    [Crashlytics startWithAPIKey:@"84bc4b5736898e3cfdb50d3d2c162c4f74480862"];

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *navBarButton = [UIImage imageNamed:@"NavBarButton.png"];
    [[UIBarButtonItem appearance] setBackgroundImage:navBarButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UIImage *backButton = [[UIImage imageNamed:@"NavBarBackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];
    [model removeAnonymousUser];
    [model loadBaseData];

    //TODO jaanus: this does not feel right
    [[TransferwiseClient sharedClient] setObjectModel:model];
    [[SupportCoordinator sharedInstance] setObjectModel:model];
    [[FeedbackCoordinator sharedInstance] setObjectModel:model];

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
    [[[GAI sharedInstance] defaultTracker] sendEventWithCategory:@"app_flow" withAction:@"AppStarted" withLabel:TRWEnvironmentTag withValue:nil];
    [[[GAI sharedInstance] trackerWithTrackingId:@"UA-16492313-3"] sendEventWithCategory:@"app_flow" withAction:@"AppStarted" withLabel:TRWEnvironmentTag withValue:nil];

    delayedExecution(60 * 2, ^{
        [[FeedbackCoordinator sharedInstance] presentFeedbackAlert];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.objectModel saveContext];
}

@end
