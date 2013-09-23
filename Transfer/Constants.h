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

#define ABSTRACT_METHOD MCLog(@"You must override %@ in a subclass", NSStringFromSelector(_cmd)); [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]

#define USE_TESTFLIGHT 1

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
  static dispatch_once_t pred = 0; \
  __strong static id _sharedObject = nil; \
  dispatch_once(&pred, ^{ \
    _sharedObject = block(); \
  }); \
  return _sharedObject; \

extern NSString *const TRWLoggedOutNotification;
extern NSString *const TRWMoveToPaymentsListNotification;
extern NSString *const TRWApplicationKey;
extern NSString *const TRWServerAddress;
extern NSString *const TRWGoogleAnalyticsTrackingId;
extern NSString *const TRWGoogleAnalyticsOtherTrackingId;

extern NSString *const TRWEnvironmentTag;

extern NSString *const TRWSupportCallNumber;
extern NSString *const TRWSupportEmail;
extern NSString *const TRWFeedbackEmail;
extern NSString *const TRWIdentificationEmail;

void delayedExecution(CGFloat seconds, TRWActionBlock action);

static NSUInteger const TransferwiseAppID = 612261027;

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
                                    green:((c>>16)&0xFF)/255.0 \
                                    blue:((c>>8)&0xFF)/255.0 \
                                    alpha:((c)&0xFF)/255.0]

#define IOS_7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

#define USE_FACEBOOK_EVENTS 0

typedef NS_OPTIONS(short, IdentificationRequired) {
	IdentificationNoneRequired = 0,
	IdentificationIdRequired = 1 << 0,
	IdentificationAddressRequired = 1 << 1,
	IdentificationPaymentPurposeRequired = 1 << 2
};


