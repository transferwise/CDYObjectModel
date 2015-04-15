//
//  PushNotificationsHelper.m
//  Transfer
//
//  Created by Juhan Hion on 13.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PushNotificationsHelper.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "AddUserDeviceOperation.h"
#import "RemoveUserDeviceOperation.h"
#import "UpdateuserDeviceOperation.h"

@interface PushNotificationsHelper ()

@property (strong, nonatomic) ObjectModel *objectModel;
@property (weak, nonatomic) UIApplication *application;
@property (strong, nonatomic) TransferwiseOperation *executingOperation;

@end

@implementation PushNotificationsHelper

#pragma mark - Init
+ (instancetype)sharedInstanceWithApplication:(UIApplication *)application
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
	UIRemoteNotificationType enabledTypes = [self.application enabledRemoteNotificationTypes];
	return  enabledTypes & UIRemoteNotificationTypeAlert && self.objectModel.currentUser.deviceToken;
}

- (void)registerForPushNotifications:(BOOL)isLaunch
{
	if ([self pushNotificationsGranted] || !isLaunch)
	{
		if(IOS_8)
		{
			UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
																								 categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
		}
		else
		{
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
		}
	}
}

- (void)handleRegistrationsSuccess:(NSData *)deviceToken
{
	NSString* tokenString = [deviceToken base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
	
	if ([self pushNotificationsGranted])
	{
		//if notification are granted update token
		UpdateUserDeviceOperation *operation = [UpdateUserDeviceOperation updateDeviceOperation];
		
		operation.objectModel = self.objectModel;
		operation.existingToken = self.objectModel.currentUser.deviceToken;
		operation.updatedToken = tokenString;
		operation.completionHandler = ^(NSError *error) {
			if (error)
			{
				NSLog(@"Token update failed: %@", error.domain);
			}
		};
		self.executingOperation = operation;
		[operation execute];
	}
	else
	{
		//this is the first time, add token
		AddUserDeviceOperation *operation = [AddUserDeviceOperation addDeviceOperation];
		
		operation.objectModel = self.objectModel;
		operation.token = tokenString;
		operation.completionHandler = ^(NSError *error) {
			if (error)
			{
				NSLog(@"Token adding failed: %@", error);
			}
		};
		self.executingOperation = operation;
		[operation execute];
	}
}

- (void)handleRegistrationFailure:(NSError *)error
{
	NSLog(@"Token registration failed: %@", error);
}

- (void)handleNotificationArrival:(NSDictionary *)userInfo
					resultHandler:(void (^)(UIBackgroundFetchResult result))handler
{
	//do the deeplinking magic here
	handler(UIBackgroundFetchResultNoData);
}

- (void)handleLoggingOut
{
	if ([self pushNotificationsGranted])
	{
		//remove device from receiving notifications
		RemoveUserDeviceOperation *operation = [RemoveUserDeviceOperation removeDeviceOperation];
	
		operation.objectModel = self.objectModel;
		operation.token = self.objectModel.currentUser.deviceToken;
		operation.completionHandler = ^(NSError *error) {
			if (error)
			{
				NSLog(@"Token removing failed: %@", error);
			}
		};
		self.executingOperation = operation;
		[operation execute];
	}
}

@end
