//
//  Constants.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Constants.h"

NSString *const TRWLoggedOutNotification = @"TRWLoggedOutNotification";
NSString *const TRWMoveToPaymentsListNotification = @"TRWMoveToPaymentsListNotification";

#if DEV_VERSION
NSString *const TRWApplicationKey = @"ad8d836d18ec18fbd4ccc7bffd71eb54";
NSString *const TRWServerAddress = @"https://api-sandbox.transferwise.com";
NSString *const TRWEnvironmentTag = @"development";
#else
NSString *const TRWApplicationKey = @"pfwk97car71rtatr1656zqyatd343dsq";
NSString *const TRWServerAddress = @"https://transferwise.com";
NSString *const TRWEnvironmentTag = @"production";
#endif

NSString *const TRWSupportCallNumber = @"+442081234020";
NSString *const TRWSupportEmail = @"support@transferwise.com";
NSString *const TRWFeedbackEmail = @"feedback@transferwise.com";
NSString *const TRWIdentificationEmail = @"id@transferwise.com";

NSString *const TRWGoogleAnalyticsTrackingId = @"UA-16492313-2";
NSString *const TRWGoogleAnalyticsOtherTrackingId = @"UA-16492313-3";

void delayedExecution(CGFloat seconds, TRWActionBlock action) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), action);
}

NSString *AppsFlyerDevKey = @"6g8vUfZXve88zupKDb94pk";
NSString *AppsFlyerIdentifier = @"612261027;6g8vUfZXve88zupKDb94pk";