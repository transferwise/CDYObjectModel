//
//  Credentials.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Credentials.h"
#import "NSString+Validation.h"
#import "Lockbox.h"

NSString *const kTWAccessTokenKey = @"kAccessTokenKey";
NSString *const kUserSecretKey = @"kUserSecretKey";
NSString *const kUserEmailKey = @"kUserEmailKey";

static NSString* accessTokenBuffer;
static NSString* emailBuffer;

@implementation Credentials

+ (BOOL)userLoggedIn {
    return [[Credentials accessToken] hasValue];
}

+ (void)setUserToken:(NSString *)token {
	[Lockbox setString:token forKey:kTWAccessTokenKey];
    accessTokenBuffer = token;
}

+ (void)setUserSecret:(NSString *)secret {
    [Lockbox setString:secret forKey:kUserSecretKey];
}

+ (void)setUserEmail:(NSString *)email {
    [Lockbox setString:email forKey:kUserEmailKey];
    emailBuffer = email;
}

+ (NSString *)accessToken {
    if(![accessTokenBuffer length]>0)
    {
        accessTokenBuffer = [Lockbox stringForKey:kTWAccessTokenKey];
    }
    return accessTokenBuffer;
}

+ (void)clearCredentials {
	[Lockbox setString:@"" forKey:kTWAccessTokenKey];
    [Lockbox setString:@"" forKey:kUserSecretKey];
    [Lockbox setString:@"" forKey:kUserEmailKey];
    accessTokenBuffer =nil;
    emailBuffer = nil;
}

+ (BOOL)temporaryAccount {
    return [[Credentials userSecret] hasValue];
}

+ (NSString *)userEmail {
    if(![emailBuffer length]>0)
    {
        emailBuffer = [Lockbox stringForKey:kUserEmailKey];
    }
    return emailBuffer;
}


+ (NSString *)userSecret {
    return [Lockbox stringForKey:kUserSecretKey];
}

@end
