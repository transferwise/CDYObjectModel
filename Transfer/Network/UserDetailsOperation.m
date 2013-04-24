//
//  UserDetailsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UserDetailsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ProfileDetails.h"

NSString *const kUserDetailsPath = @"/user/details";

@implementation UserDetailsOperation

- (void)execute {
    __block __weak UserDetailsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error %@", error);
        weakSelf.completionHandler(nil,error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        weakSelf.completionHandler(details, nil);
    }];

    NSString *fullPath = [self addTokenToPath:kUserDetailsPath];
    [self getDataFromPath:fullPath];
}

+ (UserDetailsOperation *)detailsOperation {
    return [[UserDetailsOperation alloc] init];
}

@end
