//
//  CreateRecipientOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

NSString *const kCreateRecipientPath = @"/recipient/createRecipient";

#import "CreateRecipientOperation.h"
#import "Recipient.h"
#import "TransferwiseOperation+Private.h"

@interface CreateRecipientOperation ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation CreateRecipientOperation

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kCreateRecipientPath];

    __block __weak CreateRecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        Recipient *recipient = [Recipient recipientWithData:response];
        weakSelf.responseHandler(recipient, nil);
    }];

    [self postData:self.data toPath:path];
}

+ (CreateRecipientOperation *)operationWithData:(NSDictionary *)data {
    return [[CreateRecipientOperation alloc] initWithData:data];
}

@end
