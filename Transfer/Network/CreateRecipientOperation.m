//
//  CreateRecipientOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

NSString *const kCreateRecipientPath = @"/recipient/create";
NSString *const kValidateRecipientPath = @"/recipient/validate";

#import "CreateRecipientOperation.h"
#import "Recipient.h"
#import "TransferwiseOperation+Private.h"
#import "Credentials.h"

@interface CreateRecipientOperation ()

@property (nonatomic, strong) Recipient *recipient;

@end

@implementation CreateRecipientOperation

- (id)initWithRecipient:(Recipient *)recipient {
    self = [super init];
    if (self) {
        _recipient = recipient;
    }
    return self;
}

- (void)execute {
    NSString *path;
    if ([Credentials userLoggedIn]) {
        path = [self addTokenToPath:kCreateRecipientPath];
    } else {
        path = [self addTokenToPath:kValidateRecipientPath];
    }

    __block __weak CreateRecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        Recipient *recipient = [Recipient recipientWithData:response];
        weakSelf.responseHandler(recipient, nil);
    }];

    [self postData:[self.recipient data] toPath:path];
}

+ (CreateRecipientOperation *)operationWithRecipient:(Recipient *)recipient {
    return [[CreateRecipientOperation alloc] initWithRecipient:recipient];
}

@end
