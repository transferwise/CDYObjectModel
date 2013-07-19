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
+ (void)setUserEmail:(NSString *)email;
+ (NSString *)accessToken;
+ (void)clearCredentials;
+ (BOOL)temporaryAccount;
+ (NSString *)userEmail;
+ (NSString *)userSecret;

@end
