//
//  RecipientsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 7/1/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientsOperation.h"
#import "JCSObjectModel.h"
#import "ObjectModel+Recipients.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientTypesOperation.h"

@interface RecipientsOperation ()

@property (nonatomic, strong) RecipientTypesOperation *operation;

@end

@implementation RecipientsOperation

- (void)persistRecipients:(NSDictionary *)response {
    MCAssert(self.objectModel);

    [self.workModel.managedObjectContext performBlock:^{
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Received %d recipients from server", [recipients count]);

        //TODO jaanus: test removing recipient on server and doing refresh
        void (^persistingBlock)() = ^() {
            for (NSDictionary *recipientData in recipients) {
                [self.workModel createOrUpdateRecipientWithData:recipientData];
            }

            [self.workModel saveContext:^{
                self.responseHandler(nil);
            }];
        };

        if ([self haveTypesForAllRecipients:recipients]) {
            MCLog(@"Have all needed recipient types present. Continue with persisting");
            persistingBlock();
        } else {
            MCLog(@"Pull recipient types before persisting.");
            [self retrieveTypesWithCompletion:persistingBlock];
        }
    }];
}

- (BOOL)haveTypesForAllRecipients:(NSArray *)recipients {
    for (NSDictionary *data in recipients) {
        NSString *typeCode = data[@"type"];
        if (![self.workModel haveRecipientTypeWithCode:typeCode]) {
            return NO;
        }
    }

    return YES;
}

- (void)retrieveTypesWithCompletion:(void (^)())completion {
    RecipientTypesOperation *operation = [RecipientTypesOperation operation];
    [self setOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setResultHandler:^(NSError *error) {
        if (error) {
            self.responseHandler(error);
            return;
        }

        completion();
    }];

    [operation execute];
}

@end
