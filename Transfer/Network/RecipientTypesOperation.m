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
#import "ObjectModel+RecipientTypes.h"

NSString *const kRecipientTypesPath = @"/recipient/listTypes";

@implementation RecipientTypesOperation

- (void)execute {
    NSString *path = [self addTokenToPath:kRecipientTypesPath];

    __block __weak RecipientTypesOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.resultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSArray *recipients = response[@"recipients"];
            MCLog(@"Pulled %d receipient types", [recipients count]);

            for (NSDictionary *data in recipients) {
                [weakSelf.workModel createOrUpdateRecipientTypeWithData:data];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.resultHandler(nil);
            }];
        }];
    }];

    [self getDataFromPath:path];
}

+ (RecipientTypesOperation *)operation {
    return [[RecipientTypesOperation alloc] init];
}

@end
