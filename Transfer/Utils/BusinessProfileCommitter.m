//
//  BusinessProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileCommitter.h"
#import "PlainBusinessProfileInput.h"
#import "BusinessProfileOperation.h"

@interface BusinessProfileCommitter ()

@property (nonatomic, strong) BusinessProfileOperation *executedOperation;

@end

@implementation BusinessProfileCommitter

- (void)validateBusinessProfile:(PlainBusinessProfileInput *)profile withHandler:(BusinessProfileValidationBlock)handler{
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:profile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(PlainProfileDetails *result, NSError *error) {
        handler(result, error);
    }];

    [operation execute];
}

@end
