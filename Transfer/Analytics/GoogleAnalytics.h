//
//  GoogleAnalytics.h
//  Transfer
//
//  Created by Jaanus Siim on 9/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferAnalytics.h"

@class ObjectModel;

@interface GoogleAnalytics : NSObject <TransferAnalytics>

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

@end
