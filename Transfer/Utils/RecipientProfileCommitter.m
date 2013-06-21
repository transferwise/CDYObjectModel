//
//  RecipientProfileCommitter.m
//  Transfer
//
//  Created by Jaanus Siim on 6/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientProfileCommitter.h"
#import "RecipientProfileInput.h"
#import "RecipientOperation.h"

@interface RecipientProfileCommitter ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation RecipientProfileCommitter

- (void)validateRecipient:(RecipientProfileInput *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    RecipientOperation *operation = [RecipientOperation createOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];
    [operation setResponseHandler:^(Recipient *serverRecipient, NSError *error) {
        completion(serverRecipient, error);
    }];

    [operation execute];
}

@end