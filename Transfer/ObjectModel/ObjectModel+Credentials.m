//
//  ObjectModel+Credentials.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Credentials.h"
#import "Lockbox.h"
#import "NSString+Validation.h"

NSString *const kAccessTokenKey = @"kAccessTokenKey";

@implementation ObjectModel (Credentials)

- (BOOL)userLoggedIn {
    return [[self accessToken] hasValue];
}

- (void)setUserToken:(NSString *)token {
    [Lockbox setString:token forKey:kAccessTokenKey];
}


- (NSString *)accessToken {
    return [Lockbox stringForKey:kAccessTokenKey];
}

@end
