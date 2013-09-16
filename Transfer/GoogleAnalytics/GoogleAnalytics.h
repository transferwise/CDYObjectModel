//
//  GoogleAnalytics.h
//  Transfer
//
//  Created by Jaanus Siim on 9/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalytics : NSObject

+ (GoogleAnalytics *)sharedInstance;

- (void)sendAppEvent:(NSString *)event;
- (void)sendPaymentEvent:(NSString *)event;

@end
