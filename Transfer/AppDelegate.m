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
#import "TransferwiseClient.h"
#import "ObjectModel+Users.h"
#import "GAI.h"
#import "SupportCoordinator.h"
#import "FeedbackCoordinator.h"
#import "UIColor+Theme.h"
#import "GoogleAnalytics.h"
#import "AppsFlyerTracker.h"
#import "NanTracking.h"
#import "Mixpanel.h"
#import "MOMStyle.h"
#import "ConnectionAwareViewController.h"
#import "UIFont+MOMStyle.h"
#import "UIImage+Color.h"
#import "NavigationBarCustomiser.h"
#import "EventTracker.h"
#import "Credentials.h"
#import "ObjectModel+Settings.h"
#import "IntroViewController.h"
#import <FBAppEvents.h>
#import <FBSettings.h>
#import <FBAppCall.h>
#import <NXOAuth2AccountStore.h>
#import "PushNotificationsHelper.h"

@interface AppDelegate ()

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) id<PushNotificationsProvider> notificationHelper;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //Preload keyboard by showing and removing a textfield. This prevents horrible lag the first time the user
    //enters text. iOS defect that's been around since iOS 7.1 if I'm not mistaken.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];

	[self setupThirdParties];

	[NavigationBarCustomiser setDefault];

    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    ObjectModel *model = [[ObjectModel alloc] init];
    [self setObjectModel:model];
    [model removeAnonymousUser];
    [model loadBaseData];

	self.notificationHelper = [PushNotificationsHelper sharedInstanceWithApplication:application
																		 objectModel:self.objectModel];
	[self.notificationHelper registerForPushNotifications:YES];
	
    [[GoogleAnalytics sharedInstance] setObjectModel:model];

    [[TransferwiseClient sharedClient] setObjectModel:model];
#if DEV_VERSION
    [[TransferwiseClient sharedClient] setBasicUsername:TransferSandboxUsername password:TransferSandboxPassword];
#endif

    [[SupportCoordinator sharedInstance] setObjectModel:model];
    [[FeedbackCoordinator sharedInstance] setObjectModel:model];

    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];
	
	[self initOauth];
    
	UIViewController* controller;
    
    if([Credentials userLoggedIn])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:TRWIsRegisteredSettingsKey];
    }
    
	if (![Credentials userLoggedIn] && (![self.objectModel hasIntroBeenShown] || [self.objectModel hasExistingUserIntroBeenShown]))
	{
		IntroViewController *introController = [[IntroViewController alloc] init];
		[introController setObjectModel:self.objectModel];
        introController.requireRegistration = YES;
        controller = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:introController navBarHidden:YES];
	}
	else if(![self.objectModel hasExistingUserIntroBeenShown])
	{
		IntroViewController *introController = [[IntroViewController alloc] init];
		introController.plistFilenameOverride = @"existingUserIntro";
		[introController setObjectModel:self.objectModel];
        introController.requireRegistration = ![Credentials userLoggedIn];
		[[GoogleAnalytics sharedInstance] sendScreen:@"Whats new screen"];
        controller = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:introController navBarHidden:YES];
	}
	else
	{
		MainViewController *mainController = [[MainViewController alloc] init];
		[mainController setObjectModel:self.objectModel];
		controller = mainController;
        controller = [[ConnectionAwareViewController alloc] initWithWrappedViewController:controller];
	}
	
	self.window.rootViewController = controller;
	[self.window makeKeyAndVisible];
	return YES;
}

//IOS_7
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	[self.notificationHelper handleRegistrationsSuccess:deviceToken];
}

//IOS_7
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	[self.notificationHelper handleRegistrationFailure:error];
}

//IOS_8
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
	[application registerForRemoteNotifications];
}

//IOS_8
//For interactive notification only
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void(^)())completionHandler
{
	
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[self.notificationHelper handleNotificationArrival:userInfo
										 resultHandler:completionHandler];
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

- (void)setupThirdParties
{	
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
    [Mixpanel sharedInstanceWithToken:TRWMixpanelToken];
#endif
	
	[AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFlyerDevKey;
	[AppsFlyerTracker sharedTracker].appleAppID = AppsFlyerIdentifier;
	
	
	[NanTracking setFbAppId:@"274548709260402"];
	
	[Crashlytics startWithAPIKey:@"84bc4b5736898e3cfdb50d3d2c162c4f74480862"];
	
	[NanTracking trackNanigansEvent:@"" type:@"install" name:@"main"];
	
#if !TARGET_IPHONE_SIMULATOR //Supplied library does not contain binary for simulator
	EventTracker *tracker = [EventTracker sharedManager];
#if DEBUG
    [tracker setDebug:YES];
#endif
	[tracker initEventTracker:TRWImpactRadiusAppId username:TRWImpactRadiusSID password:TRWImpactRadiusToken];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastInstalledVersion = [defaults stringForKey:TRWAppInstalledSettingsKey];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    if (![lastInstalledVersion isEqualToString:version])
    {
        if(!lastInstalledVersion)
        {
            [tracker trackInstall];
        }
        else
        {
            [tracker trackUpdate];
        }
        [defaults setObject:version forKey:TRWAppInstalledSettingsKey];
    }
    
#endif
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
	
	
    if(!urlWasHandled)
    {
        urlWasHandled = [self handleURL:url];
    }
    
    return urlWasHandled;
}

#pragma mark - deeplinking

-(BOOL)handleURL:(NSURL*)url
{
    if([[[url scheme] lowercaseString] isEqualToString:TRWDeeplinkScheme])
    {
        
        ConnectionAwareViewController* root = (ConnectionAwareViewController*) self.window.rootViewController;
        if([Credentials userLoggedIn] && [root.wrappedViewController isKindOfClass:[MainViewController class]])
        {
            MainViewController* mainController = (MainViewController*) root.wrappedViewController;
            return [mainController handleDeeplink:url];
        }
    }
    return NO;
}

#pragma mark - oauth

- (void)initOauth
{
	[[NXOAuth2AccountStore sharedStore] setClientID:GoogleOAuthClientId
											 secret:GoogleOAuthClientSecret
											  scope:[NSSet setWithObjects:GoogleOAuthEmailScope, GoogleOAuthProfileScope, nil]
								   authorizationURL:[NSURL URLWithString:GoogleOAuthAuthorizationUrl]
										   tokenURL:[NSURL URLWithString:GoogleOAuthTokenUrl]
										redirectURL:[NSURL URLWithString:GoogleOAuthRedirectUrl]
									  keyChainGroup:@""
									 forAccountType:GoogleOAuthServiceName];
}

@end
