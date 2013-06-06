//
//  Credentials.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credentials : NSObject

+ (BOOL)userLoggedIn;
+ (void)setUserToken:(NSString *)token;
+ (void)setUserSecret:(NSString *)secret;
+ (NSString *)accessToken;
+ (void)clearCredentials;
//TODO jaanus: this feels wrong place for display information
+ (NSString *)displayName;
+ (void)setDisplayName:(NSString *)displayName;
+ (BOOL)temporaryAccount;

@end
