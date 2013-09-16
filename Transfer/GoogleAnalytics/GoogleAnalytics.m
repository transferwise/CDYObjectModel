//
//  GoogleAnalytics.m
//  Transfer
//
//  Created by Jaanus Siim on 9/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "GoogleAnalytics.h"
#import "Constants.h"
#import "GAI.h"

@implementation GoogleAnalytics

+ (GoogleAnalytics *)sharedInstance {
	DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
		return [[self alloc] initSingleton];
	});
}

- (id)initSingleton {
	self = [super init];
	if (self) {

	}

	return self;
}

- (id)init {
	@throw [NSException exceptionWithName:NSInternalInconsistencyException
								   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
																	 NSStringFromClass([self class]),
																	 NSStringFromSelector(@selector(sharedClient))]
								 userInfo:nil];
	return nil;
}

- (void)sendAppEvent:(NSString *)event {
	[self sendEvent:event category:@"app_flow"];
}

- (void)sendPaymentEvent:(NSString *)event {
	[self sendEvent:event category:@"payment"];
}

- (void)sendEvent:(NSString *)event category:(NSString *)category {
	[[[GAI sharedInstance] defaultTracker] sendEventWithCategory:category withAction:event withLabel:TRWEnvironmentTag withValue:nil];
	[[[GAI sharedInstance] trackerWithTrackingId:TRWGoogleAnalyticsOtherTrackingId] sendEventWithCategory:category withAction:event withLabel:TRWEnvironmentTag withValue:nil];
}

@end
