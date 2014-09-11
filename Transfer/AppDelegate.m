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
#import "GoogleAnalytics.h"
#import "AppsFlyerTracker.h"
#import "NanTracking.h"
#import "FBSettings.h"
#import "FBAppEvents.h"
#import "Mixpanel.h"
#import "AnalyticsCoordinator.h"
#import "TransferMixpanel.h"
#import "MOMStyle.h"
#import "ConnectionAwareViewController.h"
#import "UIFont+MOMStyle.h"
#import "UIImage+Color.h"
#import "NavigationBarCustomiser.h"
#import <FBAppCall.h>

#import "Credentials.h"
#import "ObjectModel+Settings.h"
#import "IntroViewController.h"
#import "NewPaymentViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	TransferMixpanel *mixpanel = [self setupThirdParties];

	[NavigationBarCustomiser setDefault];

    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];
    [model removeAnonymousUser];
    [model loadBaseData];

    [[GoogleAnalytics sharedInstance] setObjectModel:model];
    [mixpanel setObjectModel:model];

    [[TransferwiseClient sharedClient] setObjectModel:model];
#if DEV_VERSION
    [[TransferwiseClient sharedClient] setBasicUsername:TransferSandboxUsername password:TransferSandboxPassword];
#endif

    [[SupportCoordinator sharedInstance] setObjectModel:model];
    [[FeedbackCoordinator sharedInstance] setObjectModel:model];

    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];
	
	UIViewController* controller;

	if (![Credentials userLoggedIn] && ![self.objectModel hasIntroBeenShown])
	{
		IntroViewController *introController = [[IntroViewController alloc] init];
		[introController setObjectModel:self.objectModel];
		controller = introController;
	}
	else if(![self.objectModel hasExistingUserIntroBeenShown])
	{
		IntroViewController *introController = [[IntroViewController alloc] init];
		introController.plistFilenameOverride = @"existingUserIntro";
		[introController setObjectModel:self.objectModel];
		controller = introController;
		[[GoogleAnalytics sharedInstance] sendScreen:@"Whats new screen"];
	}
	else
	{
		MainViewController *mainController = [[MainViewController alloc] init];
		[mainController setObjectModel:self.objectModel];
		ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:mainController];
		controller = root;
	}
    
	self.window.rootViewController = controller;
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
	[[AnalyticsCoordinator sharedInstance] markLoggedIn];

#if USE_FACEBOOK_EVENTS
    [FBSettings setDefaultAppID:@"274548709260402"];
    [FBAppEvents activateApp];
#endif

#if USE_APPSFLYER_EVENTS
    // Track Installs, updates & sessions (must)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
#endif

    [[TransferwiseClient sharedClient] updateConfigurationOptions];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [self.objectModel saveContext];
}

- (TransferMixpanel *)setupThirdParties
{
#if USE_TESTFLIGHT
	[TestFlight setOptions:@{TFOptionReportCrashes : @NO}];
#if DEV_VERSION
	[TestFlight takeOff:@"78f288b9-67c6-4bd3-b6ba-bf9b54645412"];
#else
	[TestFlight takeOff:@"4b176dca-177c-48bf-9480-a15001cc9211"];
#endif
#endif
	
	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#if DEBUG
	[[GAI sharedInstance] setDispatchInterval:1];
#else
	[[GAI sharedInstance] setDispatchInterval:5];
#endif
	
#if DEV_VERSION
	[[GAI sharedInstance] trackerWithTrackingId:TRWGoogleAnalyticsDevTrackingId];
#else
	[[GAI sharedInstance] trackerWithTrackingId:TRWGoogleAnalyticsTrackingId];
#endif
	
	[AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFlyerDevKey;
	[AppsFlyerTracker sharedTracker].appleAppID = AppsFlyerIdentifier;
	
	
	[NanTracking setFbAppId:@"274548709260402"];
	
	[Mixpanel sharedInstanceWithToken:TRWMixpanelToken];
	
	TransferMixpanel *mixpanel = [[TransferMixpanel alloc] init];
	[[AnalyticsCoordinator sharedInstance] addAnalyticsService:mixpanel];
	[[AnalyticsCoordinator sharedInstance] addAnalyticsService:[GoogleAnalytics sharedInstance]];
	
	[Crashlytics startWithAPIKey:@"84bc4b5736898e3cfdb50d3d2c162c4f74480862"];
	
	[NanTracking trackNanigansEvent:@"" type:@"install" name:@"main"];
	return mixpanel;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      MCLog(@"Unhandled deep link: %@", url);
                                  }];
    
    return urlWasHandled;
}

@end
