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
#import "ObjectModel.h"
#import "GAIFields.h"
#import "ObjectModel+Payments.h"

@interface GoogleAnalytics ()
@property (nonatomic, copy) NSString* pendingRecipientOrigin;
@end

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
    [self sendEvent:event category:GACategoryAppFlow label:label];
}

- (void)sendAlertEvent:(NSString *)event withLabel:(NSString *)label {
    [self sendEvent:event category:GACategoryAlert label:label];
}

- (void)sendPaymentEvent:(NSString *)event {
    [self sendPaymentEvent:event withLabel:@""];
}

- (void)sendPaymentEvent:(NSString *)event withLabel:(NSString *)label {
    [self sendEvent:event category:GACategoryPayment label:label];
}

- (void)markLoggedIn {
    NSString *email = nil;
    if ([Credentials userLoggedIn]) {
        email = [Credentials userEmail];
    }

    [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:1] value:email];
    [self markHasCompletedPayments];
}

- (void)confirmPaymentScreenShown {
    //NO OP
}

- (void)paymentPersonalProfileScreenShown {
    //NO OP
}

- (void)paymentRecipientProfileScreenShown {
    [self sendScreen:GAEnterRecipientDetails];
}

- (void)refundDetailsScreenShown {
    if ([Credentials userLoggedIn]) {
        [self sendScreen:GARefundAccount2];
    } else {
        [self sendScreen:GARefundAccount];
    }
}

- (void)refundRecipientAdded {
    [self sendPaymentEvent:GARefundAccountAdded withLabel:@"DuringPayment"];
}

- (void)sendEvent:(NSString *)event category:(NSString *)category label:(NSString *)label {
    [self sendEvent:event category:category label:label value:nil];
}

- (void)sendEvent:(NSString *)event category:(NSString *)category label:(NSString *)label value:(NSNumber*)value{
    NSMutableDictionary *eventDict = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                             action:event
                                                                              label:label
                                                                              value:value] build];
    [[[GAI sharedInstance] defaultTracker] send:eventDict];
}


- (void)markHasCompletedPayments {
    [self.objectModel performBlock:^{
        [[[GAI sharedInstance] defaultTracker] set:[GAIFields customDimensionForIndex:2] value:[self.objectModel hasCompletedPayments] ? @"Y" : @"N"];
    }];
}


-(void)pendingRecipientOrigin:(NSString*)recipientOrigin
{
    self.pendingRecipientOrigin = recipientOrigin;
}

-(void)sendNewRecipentEventWithLabel:(NSString*)label
{
    [self sendEvent:GARecipientAdded category:GACategoryRecipient label:label];
    [self sendEvent:GARecipientOrigin category:GACategoryRecipient label:self.pendingRecipientOrigin];
    self.pendingRecipientOrigin = @"Manual";
}



@end
