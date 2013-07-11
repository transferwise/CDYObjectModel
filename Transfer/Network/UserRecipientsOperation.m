//
//  UserRecipientsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UserRecipientsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Currency.h"
#import "PlainCurrency.h"

NSString *const kRecipientsListPath = @"/recipient/list";

@interface UserRecipientsOperation ()

@property (nonatomic, strong) PlainCurrency *currency;

@end

@implementation UserRecipientsOperation

- (id)initWithCurrency:(PlainCurrency *)currency {
    self = [super init];
    if (self) {
        _currency = currency;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientsListPath];

    __block __weak UserRecipientsOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf persistRecipients:response];
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(error);
    }];

    NSDictionary *params = self.currency ? @{@"currency" : self.currency.code} : @{};
    [self getDataFromPath:path params:params];
}

+ (UserRecipientsOperation *)recipientsOperation {
    return [[UserRecipientsOperation alloc] init];
}

+ (UserRecipientsOperation *)recipientsOperationWithCurrency:(PlainCurrency *)currency {
    return [[UserRecipientsOperation alloc] initWithCurrency:currency];
}

@end
