//
//  DeleteRecipientOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DeleteRecipientOperation.h"
#import "Recipient.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"

NSString *const kDeleteRecipientPath = @"/recipient/delete";

@interface DeleteRecipientOperation ()

@property (nonatomic, strong) NSNumber *recipientId;

@end

@implementation DeleteRecipientOperation

- (id)initWithRecipientId:(NSNumber *)recipientId {
    self = [super init];
    if (self) {
        _recipientId = recipientId;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kDeleteRecipientPath];

    __block __weak DeleteRecipientOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        //TODO jaanus: copy paste from UserRecipientsOperation
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

        weakSelf.completionHandler([NSArray arrayWithArray:result], nil);
    }];

    [self postData:@{@"recipientId" : self.recipientId} toPath:path];
}

+ (DeleteRecipientOperation *)operationWithRecipient:(Recipient *)recipient {
    return [[DeleteRecipientOperation alloc] initWithRecipientId:recipient.recipientId];
}


@end
