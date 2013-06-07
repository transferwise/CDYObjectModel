//
//  ClaimAccountOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 6/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ClaimAccountOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Credentials.h"

NSString *const kSetPasswordPath = @"/api/v1/account/setPassword";

@interface ClaimAccountOperation ()

@property (nonatomic, copy) NSString *password;

@end

@implementation ClaimAccountOperation

- (id)initWithPassword:(NSString *)password {
    self = [super init];
    if (self) {
        _password = password;
    }
    return self;
}

- (void)execute {
    __block __weak ClaimAccountOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [Credentials setUserSecret:@""];
        weakSelf.resultHandler(nil);
    }];

    [self postData:@{@"password": self.password, @"secret":[Credentials userSecret]} toPath:kSetPasswordPath];
}


+ (ClaimAccountOperation *)operationWithPassword:(NSString *)password {
    return [[ClaimAccountOperation alloc] initWithPassword:password];
}

@end
