//
//  YozioMetaDataCallbackable.h
//
//  Copyright (c) 2015 Yozio Inc. All rights reserved.
//
//  This file is part of the Yozio SDK.
//
//  By using the Yozio SDK in your software, you agree to the Yozio
//  terms of service which can be found at http://yozio.com/terms.

@protocol YozioMetaDataCallbackable <NSObject>

/**
 * implement this method to handle the callback from new install or deeplink.
 *
 * @param targetViewControllerName - the target view controller that you configured in Yozio Web Console.
 * @param metaData - the meta data passed to your app.
 */
- (void) onCallbackWithTargetViewControllerName:(NSString *)targetViewControllerName
                                    andMetaData:(NSDictionary *)metaData;

@end