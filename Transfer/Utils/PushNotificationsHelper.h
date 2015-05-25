//
//  PushNotificationsHelper.h
//  Transfer
//
//  Created by Juhan Hion on 13.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

@protocol PushNotificationsProvider<NSObject>

- (BOOL)pushNotificationsGranted;
- (void)registerForPushNotifications:(BOOL)isLaunch;
- (void)handleRegistrationsSuccess:(NSData *)deviceToken;
- (void)handleRegistrationFailure:(NSError *)error;
- (void)handleNotificationArrival:(NSDictionary *)userInfo;
- (void)handleLoggingOut;
- (void)handleDeviceRegistering;

+ (BOOL)shouldPresentNotificationsPrompt;

@end

@interface PushNotificationsHelper : NSObject<PushNotificationsProvider>

- (id)init __attribute__((unavailable("init unavailable, use sharedInstance")));
+ (instancetype)sharedInstanceWithApplication:(UIApplication *)application
								  objectModel:(ObjectModel *)objectModel;

@end