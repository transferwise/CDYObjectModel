//
//  BusinessProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileCommitter.h"
#import "BusinessProfileInput.h"
#import "BusinessProfileOperation.h"

@interface BusinessProfileCommitter ()

@property (nonatomic, strong) BusinessProfileOperation *executedOperation;

@end

@implementation BusinessProfileCommitter

- (void)validateBusinessProfile:(BusinessProfileInput *)profile withHandler:(BusinessProfileValidationBlock)handler{
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:profile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        handler(result, error);
    }];

    [operation execute];
}

@end
