//
//  RecipientsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 7/1/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientsOperation.h"
#import "ObjectModel+Recipients.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientTypesOperation.h"
#import "Recipient.h"

@interface RecipientsOperation ()

@property (nonatomic, strong) RecipientTypesOperation *operation;

@end

@implementation RecipientsOperation

- (void)persistRecipients:(NSDictionary *)response {
    MCAssert(self.objectModel);

    [self.workModel.managedObjectContext performBlock:^{
        NSArray *recipients = response[@"recipients"];
        MCLog(@"Received %d recipients from server", [recipients count]);

        void (^persistingBlock)() = ^() {
            NSMutableArray *existingRecipients = [NSMutableArray arrayWithArray:[self.workModel allUserRecipients]];
            for (NSDictionary *recipientData in recipients) {
                Recipient *recipient = [self.workModel createOrUpdateRecipientWithData:recipientData];
                [existingRecipients removeObject:recipient];
            }

            if ([existingRecipients count] > 0) {
                MCLog(@"%d recipients removed on server", [existingRecipients count]);
                for (Recipient *recipient in existingRecipients) {
                    [recipient setHiddenValue:YES];
                }
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
    [operation setResultHandler:^(NSError *error, NSArray* returnedRecipientTypeIdentifiers) {
        if (error) {
            self.responseHandler(error);
            return;
        }

        [self.workModel performBlock:completion];
    }];

    [operation execute];
}

@end
