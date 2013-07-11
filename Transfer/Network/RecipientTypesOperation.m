//
//  RecipientTypesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientTypesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "PlainRecipientType.h"

NSString *const kRecipientTypesPath = @"/recipient/listTypes";

@implementation RecipientTypesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientTypesPath];

    __block __weak RecipientTypesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Pulled %d receipient types", [recipients count]);

        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[recipients count]];
        for (NSDictionary *data in recipients) {
            PlainRecipientType *type = [PlainRecipientType typeWithData:data];
            [result addObject:type];
        }

        weakSelf.resultHandler([NSArray arrayWithArray:result], nil);
    }];

    [self getDataFromPath:path];
}

+ (RecipientTypesOperation *)operation {
    return [[RecipientTypesOperation alloc] init];
}

@end
