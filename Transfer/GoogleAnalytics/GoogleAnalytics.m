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
#import "Credentials.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

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

- (void)sendScreen:(NSString *)screenName {
    NSMutableDictionary *dictionary = [[[GAIDictionaryBuilder createAppView] set:screenName forKey:kGAIScreenName] build];

    [[[GAI sharedInstance] defaultTracker] send:dictionary];
}

- (void)sendAppEvent:(NSString *)event {
    [self sendAppEvent:event withLabel:@""];
}

- (void)sendAppEvent:(NSString *)event withLabel:(NSString *)label {
    [self sendEvent:event category:@"app_flow" label:label];
}

- (void)sendAlertEvent:(NSString *)event withLabel:(NSString *)label {
    [self sendEvent:event category:@"alert" label:label];
}

- (void)sendPaymentEvent:(NSString *)event {
    [self sendPaymentEvent:event withLabel:@""];
}

- (void)sendPaymentEvent:(NSString *)event withLabel:(NSString *)label {
    [self sendEvent:event category:@"payment" label:label];
}

- (void)markLoggedIn {
    NSString *marker = [Credentials userLoggedIn] ? @"YES" : @"NO";
    [[[GAI sharedInstance] defaultTracker] set:@"IsLoggedIn" value:marker];
}

- (void)sendEvent:(NSString *)event category:(NSString *)category label:(NSString *)label {
    NSMutableDictionary *eventDict = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                             action:event
                                                                              label:label
                                                                              value:nil] build];
    [[[GAI sharedInstance] defaultTracker] send:eventDict];
}

@end
