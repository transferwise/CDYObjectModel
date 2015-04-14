//
//  PushNotificationsHelper.m
//  Transfer
//
//  Created by Juhan Hion on 13.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PushNotificationsHelper.h"

@interface PushNotificationsHelper ()

@property (strong, nonatomic) ObjectModel *objectModel;
@property (weak, nonatomic) UIApplication *application;

@end

@implementation PushNotificationsHelper

#pragma mark - Init
- (instancetype)sharedInstanceWithApplication:(UIApplication *)application
								  objectModel:(ObjectModel *)objectModel
{
	static dispatch_once_t pred = 0;
	__strong static PushNotificationsHelper *sharedObject = nil;
	dispatch_once(&pred, ^{
		sharedObject = [[PushNotificationsHelper alloc] initSingleton];
	});
	
	sharedObject.objectModel = objectModel;
	sharedObject.application = application;
	
	return sharedObject;
}

- (instancetype)initSingleton
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

#pragma mark - PushNotificationProvider implementation
- (BOOL)pushNotificationsGranted
{
	UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	return  enabledTypes & UIRemoteNotificationTypeAlert;
}

- (void)registerForPushNotifications
{
	UIUserNotificationType types = UIUserNotificationTypeAlert;
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
																			 categories:nil];
	
	[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)handleRegistrationsSuccess:(NSData *)deviceToken
{
	//save token to backend
	//enable notifications
}

- (void)handleRegistrationFailure:(NSError *)error
{
	//log failure
}

- (void)handleNotificationArrival:(NSDictionary *)userInfo
					resultHandler:(void (^)(UIBackgroundFetchResult result))handler
{
	//do the deeplinking magic here
	handler(UIBackgroundFetchResultNoData);
}

- (void)handleLoggingOut
{
	
}

@end
