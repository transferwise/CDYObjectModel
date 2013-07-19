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

NSString *const kAccessTokenKey = @"kAccessTokenKey";
NSString *const kUserSecretKey = @"kUserSecretKey";
NSString *const kUserEmailKey = @"kUserEmailKey";

@implementation Credentials

+ (BOOL)userLoggedIn {
    return [[Credentials accessToken] hasValue];
}

+ (void)setUserToken:(NSString *)token {
    [Lockbox setString:token forKey:kAccessTokenKey];
}

+ (void)setUserSecret:(NSString *)secret {
    [Lockbox setString:secret forKey:kUserSecretKey];
}

+ (void)setUserEmail:(NSString *)email {
    [Lockbox setString:email forKey:kUserEmailKey];
}

+ (NSString *)accessToken {
    return [Lockbox stringForKey:kAccessTokenKey];
}

+ (void)clearCredentials {
    [Lockbox setString:@"" forKey:kAccessTokenKey];
    [Lockbox setString:@"" forKey:kUserSecretKey];
    [Lockbox setString:@"" forKey:kUserEmailKey];
}

+ (BOOL)temporaryAccount {
    return [[Credentials userSecret] hasValue];
}

+ (NSString *)userEmail {
    return [Lockbox stringForKey:kUserEmailKey];
}


+ (NSString *)userSecret {
    return [Lockbox stringForKey:kUserSecretKey];
}

@end
