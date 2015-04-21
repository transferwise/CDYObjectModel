//
//  PushNotificationDispather.m
//  Transfer
//
//  Created by Juhan Hion on 20.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PushNotificationDispather.h"

NSString *const kPaymentStatus = @"PAYMENT_STATUS";
NSString *const kTWProtocol = @"transferwise";
NSString *const kPaymentDetails = @"details";

@implementation PushNotificationDispather

- (void)dispatchNotification:(NSDictionary *)notification
			 withApplication:(UIApplication *)application
{
	if (notification[kPaymentStatus])
	{
		[self handlePaymentStatusChangeNotification:notification[kPaymentStatus]
										application:application];
	}
}

- (void)handlePaymentStatusChangeNotification:(NSString *)paymentId
								  application:(UIApplication *)application
{
	NSString *deepLink = [NSString stringWithFormat:@"%@://%@/%@", kTWProtocol, kPaymentDetails, paymentId];
	
	[application openURL:[NSURL URLWithString:deepLink]];
}

@end
