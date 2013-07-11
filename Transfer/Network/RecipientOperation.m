//
//  RecipientOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

NSString *const kCreateRecipientPath = @"/recipient/create";
NSString *const kValidateRecipientPath = @"/recipient/validate";

#import "RecipientOperation.h"
#import "PlainRecipient.h"
#import "TransferwiseOperation+Private.h"
#import "PlainRecipientProfileInput.h"

@interface RecipientOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) PlainRecipientProfileInput *recipient;

@end

@implementation RecipientOperation

- (id)initWithPath:(NSString *)path recipient:(PlainRecipientProfileInput *)recipient {
    self = [super init];
    if (self) {
        _path = path;
        _recipient = recipient;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:self.path];

    __block __weak RecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        PlainRecipient *recipient = [PlainRecipient recipientWithData:response];
        weakSelf.responseHandler(recipient, nil);
    }];

    [self postData:[self.recipient data] toPath:path];
}

+ (RecipientOperation *)createOperationWithRecipient:(PlainRecipientProfileInput *)recipient {
    return [[RecipientOperation alloc] initWithPath:kCreateRecipientPath recipient:recipient];
}

+ (RecipientOperation *)validateOperationWithRecipient:(PlainRecipientProfileInput *)recipient {
    return [[RecipientOperation alloc] initWithPath:kValidateRecipientPath recipient:recipient];
}


@end
