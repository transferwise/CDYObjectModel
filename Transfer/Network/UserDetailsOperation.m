//
//  UserDetailsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UserDetailsOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kUserDetailsPath = @"/user/details";

@implementation UserDetailsOperation

- (void)execute {
    NSString *fullPath = [self addTokenToPath:kUserDetailsPath];
    [self getDataFromPath:fullPath];
}


@end
