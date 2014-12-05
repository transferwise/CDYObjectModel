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
NSString *const TRWMoveToPaymentViewNotification = @"TRWMoveToPaymentViewNotification";

#if DEV_VERSION
NSString *const TRWApplicationKey = @"ad8d836d18ec18fbd4ccc7bffd71eb54";
NSString *const TRWServerAddress = @"https://api-sandbox.transferwise.com";
#else
NSString *const TRWApplicationKey = @"pfwk97car71rtatr1656zqyatd343dsq";
NSString *const TRWServerAddress = @"https://transferwise.com";
#endif

NSString *const TransferSandboxUsername = @"mooncascade";
NSString *const TransferSandboxPassword = @"DayAndNight";

NSString *const TRWSupportCallNumber = @"+442081234020";
NSString *const TRWSupportEmail = @"support@transferwise.com";
NSString *const TRWFeedbackEmail = @"feedback@transferwise.com";
NSString *const TRWIdentificationEmail = @"id@transferwise.com";

NSString *const TRWUploadProgressNotification = @"TRWUploadProgressNotification";
NSString *const TRWUploadProgressKey = @"TRWUploadProgressKey";
NSString *const TRWUploadFileKey = @"TRWUploadFileKey";

NSString *const TRWGoogleAnalyticsTrackingId = @"UA-16492313-2";
NSString *const TRWGoogleAnalyticsDevTrackingId = @"UA-24270670-3";
NSString *const TRWGoogleTagManagerContainerId = @"GTM-TDZF76";

NSString *const TRWMixpanelToken = @"96ffee966b209ba8b874598f4d936ff6";

NSString *const TRWAppType = @"IosApp";

NSString *const TRWImpactRadiusAppId = @"6598";
NSString *const TRWImpactRadiusSID = @"IR4gjNxRYJ6d26091rA9zo7rpJBPnosnn2";
NSString *const TRWImpactRadiusToken = @"e4rpBDiFcRCgQ4NsponLbPqzBcS8wAE9";

NSString *const TRWRateAppUrl = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=612261027&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
NSString *const TRWToSUrl = @"/terms-of-use";
NSString *const TRWPrivacyUrl = @"/privacy-policy";
NSString *const TRWStateSpecificTermsUrl = @"/terms-and-conditions?execution=e1s2";

void delayedExecution(CGFloat seconds, TRWActionBlock action) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), action);
}

NSString *AppsFlyerDevKey = @"6g8vUfZXve88zupKDb94pk";
NSString *AppsFlyerIdentifier = @"612261027;6g8vUfZXve88zupKDb94pk";

NSString *const TRWAppInstalledSettingsKey = @"TRWAppInstalledSettingsKey";