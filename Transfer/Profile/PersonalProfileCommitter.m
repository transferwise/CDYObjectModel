//
//  PersonalProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileCommitter.h"
#import "TransferwiseOperation.h"
#import "PersonalProfileOperation.h"
#import "Constants.h"
#import "ObjectModel.h"
#import "GoogleAnalytics.h"

@interface PersonalProfileCommitter ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation PersonalProfileCommitter

- (void)validatePersonalProfile:(NSManagedObjectID *)profileID withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"Commit profile");
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"PersonalProfileSaved"];
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:profileID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        handler(error);
    }];

    [operation execute];
}

@end
