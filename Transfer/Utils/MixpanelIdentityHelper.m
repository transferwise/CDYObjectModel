//
//  MixpanelIdentityHelper.m
//  Transfer
//
//  Created by Juhan Hion on 15.06.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "MixpanelIdentityHelper.h"
#import <Mixpanel.h>

@implementation MixpanelIdentityHelper

+ (void)handleRegistration:(NSString *)userId
{
	NSString *mixpanelId = [Mixpanel sharedInstance].distinctId;
	
	[[Mixpanel sharedInstance] createAlias:userId
							 forDistinctID:mixpanelId];
	[[Mixpanel sharedInstance] identify:mixpanelId];
}

+ (void)handleLogin:(NSString *)userId
{
	[[Mixpanel sharedInstance] identify:userId];
}

@end
