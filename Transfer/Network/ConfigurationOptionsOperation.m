//
//  ConfigurationOptionsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 10/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ConfigurationOptionsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NSDictionary+Cleanup.h"
#import "ObjectModel+PendingPayments.h"
#import "ObjectModel+Settings.h"

NSString *const kOptionsPath = @"/option/status";

@implementation ConfigurationOptionsOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kOptionsPath];

    __weak ConfigurationOptionsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        [weakSelf handleOptionsResponse:@{}];
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf handleOptionsResponse:response];
    }];

    [self getDataFromPath:path];
}

- (void)handleOptionsResponse:(NSDictionary *)rawData {
    NSMutableDictionary *data = [[rawData dictionaryByRemovingNullObjects] mutableCopy];
    if (!data[@"askForIPhoneReview"]) {
        data[@"askForIPhoneReview"] = @YES;
    }

    if (!data[@"useDirectIPhoneUserSignup"]) {
        data[@"useDirectIPhoneUserSignup"] = @NO;
    }

    [self.workModel performBlock:^{
        [self.workModel markReviewsEnabled:[data[@"askForIPhoneReview"] boolValue]];
        [self.workModel markDirectSignupEnabled:[data[@"useDirectIPhoneUserSignup"] boolValue]];
        self.completion();
    }];
}

@end
