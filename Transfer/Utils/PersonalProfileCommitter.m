//
//  PersonalProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileCommitter.h"
#import "PersonalProfileInput.h"
#import "TransferwiseOperation.h"
#import "PersonalProfileOperation.h"
#import "Constants.h"

@interface PersonalProfileCommitter ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation PersonalProfileCommitter

- (void)validateProfile:(PersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"Validate profile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:profile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        handler(result, error);
    }];

    [operation execute];
}

@end
