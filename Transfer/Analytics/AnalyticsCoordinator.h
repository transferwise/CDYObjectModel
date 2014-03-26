//
//  AnalyticsCoordinator.h
//  Transfer
//
//  Created by Jaanus Siim on 26/03/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferAnalytics.h"

@protocol TransferAnalytics;

@interface AnalyticsCoordinator : NSObject <TransferAnalytics>

+ (AnalyticsCoordinator *)sharedInstance;

- (void)addAnalyticsService:(id<TransferAnalytics>)service;

@end
