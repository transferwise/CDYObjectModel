//
//  UserDetailsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UserDetailsOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"
#import "ObjectModel+Users.h"

NSString *const kUserDetailsPath = @"/user/details";

@implementation UserDetailsOperation

- (void)execute {
    MCAssert(self.objectModel);

    __block __weak UserDetailsOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        MCLog(@"Error %@", error);
        weakSelf.completionHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            [weakSelf.workModel createOrUpdateUserWithData:response];

            [weakSelf.workModel saveContext:^{
                weakSelf.completionHandler(nil);
            }];
        }];
    }];

    NSString *fullPath = [self addTokenToPath:kUserDetailsPath];
    [self getDataFromPath:fullPath];
}

+ (UserDetailsOperation *)detailsOperation {
    return [[UserDetailsOperation alloc] init];
}

@end
