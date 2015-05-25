//
//  PushNotificationDispather.h
//  Transfer
//
//  Created by Juhan Hion on 20.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PushNotificationDispatcher <NSObject>

- (void)dispatchNotification:(NSDictionary *)notification
			 withApplication:(UIApplication *)application;

@end

@interface PushNotificationDispather : NSObject<PushNotificationDispatcher>

@end
