//
//  RecipientProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 6/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientProfileCommitter.h"
#import "RecipientOperation.h"
#import "ObjectModel.h"

@interface RecipientProfileCommitter ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation RecipientProfileCommitter

- (void)validateRecipient:(NSManagedObjectID *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    RecipientOperation *operation = [RecipientOperation createOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setResponseHandler:completion];

    [operation execute];
}
@end
