//
//  DeleteRecipientOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DeleteRecipientOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Recipient.h"

NSString *const kDeleteRecipientPath = @"/recipient/delete";

@interface DeleteRecipientOperation ()

@property (nonatomic, strong) NSNumber *recipientId;

@end

@implementation DeleteRecipientOperation

- (id)initWithRecipientId:(NSNumber *)recipientId {
    self = [super init];
    if (self) {
        _recipientId = recipientId;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kDeleteRecipientPath];

    __block __weak DeleteRecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(error);
    }];

    //TODO jaanus: if recipient has local payments, then just hide deleted recipient
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf persistRecipients:response];
    }];

    [self postData:@{@"recipientId" : self.recipientId} toPath:path];
}

+ (DeleteRecipientOperation *)operationWithRecipient:(Recipient *)recipient {
    return [[DeleteRecipientOperation alloc] initWithRecipientId:recipient.remoteId];
}


@end
