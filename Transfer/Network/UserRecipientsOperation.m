//
//  UserRecipientsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UserRecipientsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "PlainRecipient.h"
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
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Received %d recipients from server", [recipients count]);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[recipients count]];
        for (NSDictionary *recipientData in recipients) {
            PlainRecipient *recipient = [PlainRecipient recipientWithData:recipientData];
            [result addObject:recipient];
        }
        [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PlainRecipient *one = obj1;
            PlainRecipient *two = obj2;
            return [one.name compare:two.name options:NSCaseInsensitiveSearch];
        }];

        weakSelf.responseHandler([NSArray arrayWithArray:result], nil);
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
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
