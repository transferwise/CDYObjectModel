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
#import "Credentials.h"
#import "NSData+HexString.h"
#import "PushNotificationDispather.h"

@interface PushNotificationsHelper ()

@property (strong, nonatomic) ObjectModel *objectModel;
@property (weak, nonatomic) UIApplication *application;
@property (strong, nonatomic) TransferwiseOperation *executingOperation;
@property (strong, nonatomic) NSString *deviceTokenString;
@property (strong, nonatomic) id<PushNotificationDispatcher> notificationDispatcher;

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
	sharedObject.notificationDispatcher = [[PushNotificationDispather alloc] init];
	
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
	if (IOS_8)
	{
		return [self.application isRegisteredForRemoteNotifications];
	}
	else
	{
		UIRemoteNotificationType enabledTypes = [self.application enabledRemoteNotificationTypes];
		return  enabledTypes & UIRemoteNotificationTypeAlert;
	}
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
	self.deviceTokenString = [deviceToken hexString];
	
	[self handleDeviceRegistering];
}

- (void)handleDeviceRegistering
{
	//only register device token when logged in
	if ([Credentials userLoggedIn]
		&& [self pushNotificationsGranted]
		&& self.deviceTokenString)
	{
		if ([self.objectModel.currentUser.deviceToken length] > 0)
		{
			//if token exist update token just in case (as per Apple docs)
			UpdateUserDeviceOperation *operation = [UpdateUserDeviceOperation updateDeviceOperation];
			
			operation.objectModel = self.objectModel;
			operation.existingToken = self.objectModel.currentUser.deviceToken;
			operation.updatedToken = self.deviceTokenString;
			operation.completionHandler = ^(NSError *error) {
				if (error)
				{
					MCLog(@"Token update failed: %@", error.domain);
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
			operation.token = self.deviceTokenString;
			operation.completionHandler = ^(NSError *error) {
				if (error)
				{
					MCLog(@"Token adding failed: %@", error);
				}
			};
			self.executingOperation = operation;
			[operation execute];
		}
	}
}

- (void)handleRegistrationFailure:(NSError *)error
{
	MCLog(@"Token registration failed: %@", error);
}

- (void)handleNotificationArrival:(NSDictionary *)userInfo
{
	[self.notificationDispatcher dispatchNotification:userInfo
									  withApplication:self.application];
}

- (void)handleLoggingOut
{
	if ([self pushNotificationsGranted] && [self.objectModel.currentUser.deviceToken length] > 0)
	{
		//remove device from receiving notifications
		RemoveUserDeviceOperation *operation = [RemoveUserDeviceOperation removeDeviceOperation];
	
		operation.objectModel = self.objectModel;
		operation.token = self.objectModel.currentUser.deviceToken;
		operation.completionHandler = ^(NSError *error) {
			if (error)
			{
				MCLog(@"Token removing failed: %@", error);
			}
		};
		self.executingOperation = operation;
		[operation execute];
	}
}

#pragma mark - custom user prompt

+(BOOL)shouldPresentNotificationsPrompt
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL hasDeclined = [defaults boolForKey:TRWHasRespondedToNotificationsPromptSettingsKey];
    return !hasDeclined;
}

@end
