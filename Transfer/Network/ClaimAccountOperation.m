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
#import "GoogleAnalytics.h"
#import "Constants.h"
#import "AppsFlyerTracker.h"
#import "ObjectModel+Users.h"
#import "User.h"

NSString *const kSetPasswordPath = @"/account/setPassword";

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
    NSString *path = [self addTokenToPath:kSetPasswordPath];

    __block __weak ClaimAccountOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [Credentials setUserSecret:@""];

		[[GoogleAnalytics sharedInstance] sendAppEvent:@"UserRegistered" withLabel:@"tw"];

#if USE_APPSFLYER_EVENTS
        [weakSelf.workModel performBlock:^{
            [AppsFlyerTracker sharedTracker].customerUserID = [weakSelf.workModel.currentUser pReference];
            [[AppsFlyerTracker sharedTracker] trackEvent:@"registration" withValue:@""];
        }];
#endif

        weakSelf.resultHandler(nil);
    }];

    [self postData:@{@"password": self.password, @"secret":[Credentials userSecret]} toPath:path];
}


+ (ClaimAccountOperation *)operationWithPassword:(NSString *)password {
    return [[ClaimAccountOperation alloc] initWithPassword:password];
}

@end
