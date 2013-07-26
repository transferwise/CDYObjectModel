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
#import "TransferwiseOperation+Private.h"
#import "JCSObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "Recipient.h"
#import "Constants.h"

@interface RecipientOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSManagedObjectID *recipient;

@end

@implementation RecipientOperation

- (id)initWithPath:(NSString *)path recipient:(NSManagedObjectID *)recipient {
    self = [super init];
    if (self) {
        _path = path;
        _recipient = recipient;
    }
    return self;
}

- (void)execute {
    MCLog(@"execute");
    NSString *path = [self addTokenToPath:self.path];

    __block __weak RecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.responseHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            NSNumber *remoteId = response[@"id"];
            if (remoteId) {
                Recipient *recipient = (Recipient *) [weakSelf.workModel.managedObjectContext objectWithID:weakSelf.recipient];
                [recipient setRemoteId:remoteId];
                [recipient setTemporaryValue:NO];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.responseHandler(nil);
            }];
        }];
    }];

    [self.workModel performBlock:^{
        Recipient *recipient = (Recipient *) [weakSelf.workModel.managedObjectContext objectWithID:self.recipient];
        [self postData:[recipient data] toPath:path];
    }];
}

+ (RecipientOperation *)createOperationWithRecipient:(NSManagedObjectID *)recipient {
    return [[RecipientOperation alloc] initWithPath:kCreateRecipientPath recipient:recipient];
}

+ (RecipientOperation *)validateOperationWithRecipient:(NSManagedObjectID *)recipient {
    return [[RecipientOperation alloc] initWithPath:kValidateRecipientPath recipient:recipient];
}


@end
