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

@implementation Credentials

+ (BOOL)userLoggedIn {
    return [[Credentials accessToken] hasValue];
}

+ (void)setUserToken:(NSString *)token {
    [Lockbox setString:token forKey:kAccessTokenKey];
}

+ (NSString *)accessToken {
    return [Lockbox stringForKey:kAccessTokenKey];
}

+ (void)clearCredentials {
    [Lockbox setString:@"" forKey:kAccessTokenKey];
}

@end
