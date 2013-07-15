//
//  PersonalProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileCommitter.h"
#import "PlainPersonalProfileInput.h"
#import "TransferwiseOperation.h"
#import "PersonalProfileOperation.h"
#import "Constants.h"
#import "ObjectModel.h"

@interface PersonalProfileCommitter ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation PersonalProfileCommitter

- (void)validatePersonalProfile:(PlainPersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"Validate profile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        handler(nil, error);
    }];

    [operation execute];
}

@end
