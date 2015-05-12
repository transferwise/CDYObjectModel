//
//  Yozio.h
//
//  Copyright (c) 2015 Yozio. All rights reserved.
//
//  This file is part of the Yozio SDK.
//
//  By using the Yozio SDK in your software, you agree to the Yozio
//  terms of service which can be found at http://yozio.com/terms.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YozioMetaDataCallbackable.h"

@interface Yozio : NSObject

/**
 * configures the Yozio SDK. Must be called when your app is launched and before any other method. 
 * you can find your app key and secret key in console.yozio.com > Your app > Settings > Integeration Info.
 *
 * @param appKey - yozio provided app key
 * @param secretKey - yozio provided secret key
 * @param newInstallMetaDataCallback - callback instance to handle meta data passed by new install or nil
 * @param deepLinkMetaDataCallback - callback instance to handle meta data passed by deep link or nil
 *
 */
+ (void)initializeWithAppKey:(NSString *)appKey andSecretKey:(NSString *)secretKey
  andNewInstallMetaDataCallback:(NSObject<YozioMetaDataCallbackable> *)newInstallMetaDataCallback
    andDeepLinkMetaDataCallback:(NSObject<YozioMetaDataCallbackable> *)deepLinkMetaDataCallback;

/**
 * check if it's a Yozio DeepLink.
 *
 * 1) if it's a Yozio DeepLink, it will handle it according to your configuration on Yozio Web Console, and return TRUE.
 * 2) if it's not a Yozio Deeplink (i.e. your existing DeepLinks), it will return FALSE, so you can handle them accordingly.
 *
 * @param url - NSURL object passed by app delegate
 *
 * @return true if url is a yozio deeplink, else return false.
 *
 */
+ (BOOL)handleDeeplink:(NSURL *)url;

/**
 * when the a new install is detected, Yozio will try to find the yozio short link user clicked
 * before he/she downloaded app. if the link has any meta data attached, Yozio SDK will
 * try to return these meta data through the NewInstallMetadataCallback.
 *
 * these meta data are stored in a file locally, and you can access them any time by calling the
 * following 2 functions.
 */
+ (NSDictionary *)getNewInstallMetaDataAsHash;
+ (NSString *)getNewInstallMetaDataAsUrlParameterString;

/**
 * tracks standard signup event.
 */
+ (void)trackSignup;

/**
 * tracks payment event.
 *
 * @param amount - the payment amount.
 */
+ (void)trackPayment:(double)amount;

/**
 * tracks custom downstream event.
 *
 * @param name - the event name.
 * @param value - the event value.
 */
+ (void)trackCustomEventWithName:(NSString *)name
                        andValue:(double)value;

@end

