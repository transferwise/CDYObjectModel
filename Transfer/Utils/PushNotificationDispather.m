//
//  PushNotificationDispather.m
//  Transfer
//
//  Created by Juhan Hion on 20.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PushNotificationDispather.h"
#import "Constants.h"
#import "AppDelegate.h"

NSString *const kPaymentStatus = @"PAYMENT_STATUS";

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
	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[delegate performNavigation:PaymentDetails
				 withParameters:@{kNavigationParamsPaymentId: paymentId}];
}

@end
