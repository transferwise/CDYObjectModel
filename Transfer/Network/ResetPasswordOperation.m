//
//  ResetPasswordOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ResetPasswordOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kResetPasswordPath = @"/account/forgotPassword";

@implementation ResetPasswordOperation

- (void)execute {
    __weak ResetPasswordOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        weakSelf.resultHandler(nil);
    }];

    NSString *path = [self addTokenToPath:kResetPasswordPath];

    [self postData:@{@"email" : self.email} toPath:path];
}

@end
