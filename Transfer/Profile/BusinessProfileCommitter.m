//
//  BusinessProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileCommitter.h"
#import "BusinessProfileOperation.h"
#import "ObjectModel.h"
#import "GoogleAnalytics.h"

@interface BusinessProfileCommitter ()

@property (nonatomic, strong) BusinessProfileOperation *executedOperation;

@end

@implementation BusinessProfileCommitter

- (void)validateBusinessProfile:(NSManagedObjectID *)profile
					withHandler:(BusinessProfileValidationBlock)handler
{
    [[GoogleAnalytics sharedInstance] sendAppEvent:GABusinessprofilesaved];
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:handler];

    [operation execute];
}

@end
