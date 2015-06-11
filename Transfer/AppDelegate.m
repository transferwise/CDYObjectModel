//
//  AppDelegate.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "ObjectModel.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
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
#import <FBSDKAppEvents.h>
#import <FBSDKSettings.h>
#import <NXOAuth2AccountStore.h>
#import "PushNotificationsHelper.h"
#import "Yozio.h"
#import "ReferralsCoordinator.h"
#import <FBSDKApplicationDelegate.h>

@interface AppDelegate ()<AppsFlyerTrackerDelegate, YozioMetaDataCallbackable>

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
	
	return [[FBSDKApplicationDelegate sharedInstance] application:application
									didFinishLaunchingWithOptions:launchOptions];
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
	[self.notificationHelper handleNotificationArrival:userInfo];
	//we aren't loading any data here
	completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[self.notificationHelper handleNotificationArrival:userInfo];
	//we aren't loading any data here
	completionHandler(UIBackgroundFetchResultNoData);
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
	[[GoogleAnalytics sharedInstance] sendAppEvent:GAAppstarted];
	[[GoogleAnalytics sharedInstance] markLoggedIn];

#if USE_FACEBOOK_EVENTS
    [FBSDKAppEvents activateApp];
#endif

#if USE_APPSFLYER_EVENTS
    // Track Installs, updates & sessions (must)
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
#endif

    [[TransferwiseClient sharedClient] updateBaseData];
    
    [self.notificationHelper registerForPushNotifications:YES];
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
    
    [Yozio initializeWithAppKey:@"6e774e8a-7d01-46c1-918a-ea053bb46dc9"
                   andSecretKey:@"dd39f3e4-54b3-42cc-a49a-67da6af61ac2"
  andNewInstallMetaDataCallback: self
    andDeepLinkMetaDataCallback: self];
    
#endif
	
	[AppsFlyerTracker sharedTracker].appsFlyerDevKey = AppsFlyerDevKey;
	[AppsFlyerTracker sharedTracker].appleAppID = AppsFlyerIdentifier;
#if DEBUG
    [AppsFlyerTracker sharedTracker].delegate = self;
#endif
	
	[NanTracking setFbAppId:@"274548709260402"];
	
	[Fabric with:@[CrashlyticsKit]];
	
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
    
	BOOL urlWasHandled = [Yozio handleDeeplink:url];
	
	if(!urlWasHandled)
	{
		urlWasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
																	   openURL:url
															 sourceApplication:sourceApplication
																	annotation:annotation];
	}
	
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
		return [self handleDeeplink:url];
    }
    return NO;
}

- (BOOL)handleDeeplink:(NSURL *)deepLink
{
	NSString *absolute = [deepLink absoluteString];
	NSRange startingPoint = [absolute rangeOfString:@"://"];
	NSString *parameterString = [absolute substringFromIndex:startingPoint.location + startingPoint.length];
	NSArray *parameters = [parameterString componentsSeparatedByString:@"/"];
	MCLog(@"Parameters: %@",parameters);
    
	if([parameters count] > 0)
	{
		if ([[parameters[0] lowercaseString] isEqualToString:@"details"])
		{
			if(parameters[1])
			{
				[self performNavigation:PaymentDetails
						 withParameters:@{kNavigationParamsPaymentId: parameters[1]}];
			}
			return YES;
		}
		else if ([[parameters[0] lowercaseString] isEqualToString:@"newpayment"])
		{
			[self performNavigation:NewPayment
								withParameters:nil];
			return YES;
		}
		else if ([[parameters[0] lowercaseString] isEqualToString:@"invite"])
		{
			[self performNavigation:Invite
								withParameters:nil];
			return YES;
		}
		else if ([[parameters[0] lowercaseString] isEqualToString:@"verification"])
		{
			[self performNavigation:Verification
								withParameters:nil];
			return YES;
		}
	}
	return NO;
}

#pragma mark - Perform Navigation

- (BOOL)performNavigation:(NavigationAction)navigationAction
		   withParameters:(NSDictionary *)params
{
	//don't deliver payment status notifications when app is running
	if (navigationAction == PaymentDetails && [UIApplication sharedApplication].applicationState == UIApplicationStateActive)
	{
		return NO;
	}
	
	ConnectionAwareViewController* root = (ConnectionAwareViewController*) self.window.rootViewController;
	if([Credentials userLoggedIn] && [root.wrappedViewController isKindOfClass:[MainViewController class]])
	{
        
        NSString *trackingLabel;
        switch (navigationAction) {
            case PaymentDetails:
                trackingLabel = @"payment details";
                break;
            case Invite:
                trackingLabel = @"invite";
                break;
            case NewPayment:
                trackingLabel = @"new payment";
                break;
            case Verification:
                trackingLabel = @"verification";
                break;
        }
        
        [[GoogleAnalytics sharedInstance] sendAppEvent:GADeeplink withLabel:trackingLabel];
        [[Mixpanel sharedInstance] track:MPDeeplink properties:@{MPDeeplink:trackingLabel}];
        
		MainViewController* mainController = (MainViewController*) root.wrappedViewController;
		return [mainController performNavigation:navigationAction
								  withParameters:params];
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

#pragma AppsFlyerTrackerDelegate methods
- (void) onConversionDataReceived:(NSDictionary*) installData{
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        MCLog(@"This is a none organic install.");
        MCLog(@"Media source: %@",sourceID);
        MCLog(@"Campaign: %@",campaign);
    } else if([status isEqualToString:@"Organic"]) {
        MCLog(@"This is an organic install.");
    }
}

- (void) onConversionDataRequestFailure:(NSError *)error{
    MCLog(@"Failed to get data from AppsFlyer's server: %@",[error localizedDescription]);
}

#pragma mark - Yozio

-(void)onCallbackWithTargetViewControllerName:(NSString *)targetViewControllerName andMetaData:(NSDictionary *)metaData
{
    [ReferralsCoordinator handleReferralParameters:metaData];
}



@end
