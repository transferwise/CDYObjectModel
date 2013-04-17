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
#import "ObjectModel.h"
#import "ObjectModel+Recipients.h"

NSString *const kRecipientsListPath = @"/recipient/list";

@implementation UserRecipientsOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientsListPath];

    __block __weak UserRecipientsOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Received %d recipients from server", [recipients count]);
        for (NSDictionary *recipient in recipients) {
            [weakSelf.objectModel createOrUpdateRecipientWithData:recipient];
        }
        [weakSelf.objectModel saveContext];
        weakSelf.responseHandler(nil);
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(error);
    }];

    [self getDataFromPath:path];
}

+ (UserRecipientsOperation *)recipientsOperation {
    return [[UserRecipientsOperation alloc] init];
}

@end
