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
#import "Recipient.h"

NSString *const kRecipientsListPath = @"/recipient/list";

@implementation UserRecipientsOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientsListPath];

    __block __weak UserRecipientsOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Received %d recipients from server", [recipients count]);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:[recipients count]];
        for (NSDictionary *recipientData in recipients) {
            Recipient *recipient = [Recipient recipientWithData:recipientData];
            [result addObject:recipient];
        }
        [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Recipient *one = obj1;
            Recipient *two = obj2;
            return [one.name compare:two.name options:NSCaseInsensitiveSearch];
        }];

        weakSelf.responseHandler([NSArray arrayWithArray:result], nil);
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(nil, error);
    }];

    [self getDataFromPath:path];
}

+ (UserRecipientsOperation *)recipientsOperation {
    return [[UserRecipientsOperation alloc] init];
}

@end
