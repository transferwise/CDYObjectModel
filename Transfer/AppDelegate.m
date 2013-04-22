//
//  AppDelegate.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "AppDelegate.h"
#import "ObjectModel.h"
#import "MainViewController.h"
#import "Constants.h"
#import "TestFlight.h"
#import "TransferwiseClient.h"

@interface AppDelegate ()

@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if USE_TESTFLIGHT
    [TestFlight takeOff:@"4b176dca-177c-48bf-9480-a15001cc9211"];
#endif

    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImage *navBarButton = [UIImage imageNamed:@"NavBarButton.png"];
    [[UIBarButtonItem appearance] setBackgroundImage:navBarButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];

    [[TransferwiseClient sharedClient] setObjectModel:model];

    MainViewController *controller = [[MainViewController alloc] init];
    [controller setObjectModel:model];
    [self.window setRootViewController:controller];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [[TransferwiseClient sharedClient] updateCurrencyPairs];

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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.objectModel saveContext];
}

@end
