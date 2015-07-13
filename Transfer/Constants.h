//
//  Constants.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#if DEBUG
#define MCLog(s, ...) NSLog( @"<%@:%@ (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

// A better assert. NSAssert is too runtime dependant, and assert() doesn't log.
// http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html
// Accepts both:
// - MCAssert(x > 0);
// - MCAssert(y > 3, @"Bad value for y");
#define MCAssert(expression, ...) \
do { if(!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }} while(0)

#else
#define MCLog(s, ...) //
#define MCAssert(expression, ...) //
#endif

typedef void (^TRWActionBlock)();
typedef void (^TRWErrorBlock)(NSError *error);

#define ABSTRACT_METHOD MCLog(@"You must override %@ in a subclass", NSStringFromSelector(_cmd)); [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject; \

#define TRW_MAX_CONCURRENT_OPERATIONS 5

extern NSString *const TRWLoggedOutNotification;
extern NSString *const TRWMoveToPaymentsListNotification;
extern NSString *const TRWMoveToPaymentViewNotification;
extern NSString *const TRWWillUpdateBaseDataNotification;
extern NSString *const TRWDidUpdateBaseDataNotification;

extern NSString *const TRWApplicationKey;
extern NSString *const TRWServerAddress;
extern NSString *const TRWGoogleAnalyticsTrackingId;
extern NSString *const TRWGoogleAnalyticsDevTrackingId;
extern NSString *const TRWMixpanelDevToken;
extern NSString *const TRWMixpanelToken;
extern NSString *const TRWImpactRadiusSID;
extern NSString *const TRWImpactRadiusToken;
extern NSString *const TRWImpactRadiusAppId;
extern NSString *const TRWGoogleTagManagerContainerId;

extern NSString *const TRWAppInstalledSettingsKey;
extern NSString *const TRWIsRegisteredSettingsKey;
extern NSString *const TRWHasRespondedToNotificationsPromptSettingsKey;
extern NSString *const TRWReferralTokenKey;
extern NSString *const TRWReferralSourceKey;
extern NSString *const TRWReferrerKey;
extern NSString *const TRWGoogleLoginUsedKey;
extern NSString *const TRWGoogleRevokeUrlFormat;
extern NSString *const TRWFacebookLoginUsedKey;
extern NSString *const TRWIntroABKey;
extern NSString *const TRWDidHighlightInviteSection;
extern NSString *const TRWDisableApplePay;


extern NSString *const TransferSandboxUsername;
extern NSString *const TransferSandboxPassword;

extern NSString *const TRWSupportCallNumber;
extern NSString *const TRWSupportCallNumberUS;
extern NSString *const TRWSupportEmail;
extern NSString *const TRWFeedbackEmail;
extern NSString *const TRWIdentificationEmail;

extern NSString *const TRWUploadProgressNotification;
extern NSString *const TRWUploadProgressKey;
extern NSString *const TRWUploadFileKey;
extern NSString *const TRWAppType;
extern NSString *const TRWRateAppUrl;
extern NSString *const TRWToSUrl;
extern NSString *const TRWPrivacyUrl;
extern NSString *const TRWStateSpecificTermsUrl;

extern NSString *const TRWDeeplinkScheme;


void delayedExecution(NSTimeInterval seconds, TRWActionBlock action);

static NSUInteger const TransferwiseAppID = 612261027;

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
                                    green:((c>>16)&0xFF)/255.0 \
                                    blue:((c>>8)&0xFF)/255.0 \
                                    alpha:((c)&0xFF)/255.0]

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define IOS_8 ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)  

#define IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#define USE_FACEBOOK_EVENTS 1
#define USE_APPSFLYER_EVENTS 1


typedef NS_OPTIONS(short, IdentificationRequired) {
	IdentificationNoneRequired = 0,
	IdentificationIdRequired = 1 << 0,
	IdentificationAddressRequired = 1 << 1,
	IdentificationPaymentPurposeRequired = 1 << 2,
    IdentificationSSNRequired = 1 << 3
};

extern NSString *AppsFlyerDevKey;
extern NSString *AppsFlyerIdentifier;

extern NSString *const GoogleOAuthClientId;
extern NSString *const GoogleOAuthClientSecret;
extern NSString *const GoogleOAuthAuthorizationUrl;
extern NSString *const GoogleOAuthTokenUrl;
extern NSString *const GoogleOAuthRedirectUrl;
extern NSString *const GoogleOAuthServiceName;
extern NSString *const GoogleOAuthEmailScope;
extern NSString *const GoogleOAuthProfileScope;

extern NSString *const FacebookOAuthServiceName;
extern NSString *const FacebookOAuthEmailScope;
extern NSString *const FacebookOAuthProfileScope;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

typedef NS_ENUM(short, NavigationAction) {
	PaymentDetails,
	NewPayment,
	Invite,
	Verification
};

extern NSString *const kNavigationParamsPaymentId;
