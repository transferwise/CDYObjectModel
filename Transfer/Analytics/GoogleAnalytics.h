//
//  GoogleAnalytics.h
//  Transfer
//
//  Created by Jaanus Siim on 9/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnalyticsConstants.h"

@class ObjectModel;

@interface GoogleAnalytics : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;

+ (GoogleAnalytics *)sharedInstance;

- (void)sendScreen:(NSString *)screenName;
- (void)sendAppEvent:(NSString *)event;
- (void)sendAppEvent:(NSString *)event withLabel:(NSString *)label;
- (void)sendAlertEvent:(NSString *)event withLabel:(NSString *)label;
- (void)sendPaymentEvent:(NSString *)event;
- (void)sendPaymentEvent:(NSString *)event withLabel:(NSString *)label;
- (void)sendEvent:(NSString *)event category:(NSString *)category label:(NSString *)label;
- (void)markHasCompletedPayments;

- (void)markLoggedIn;
- (void)paymentRecipientProfileScreenShown;
- (void)refundDetailsScreenShown;
- (void)refundRecipientAdded;

-(void)pendingRecipientOrigin:(NSString*)recipientOrigin;
-(void)sendNewRecipentEventWithLabel:(NSString*)label;
@end
