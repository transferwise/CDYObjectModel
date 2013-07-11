//
//  DeleteRecipientOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "UserRecipientsOperation.h"

@class PlainRecipient;

@interface DeleteRecipientOperation : RecipientsOperation

+ (DeleteRecipientOperation *)operationWithRecipient:(PlainRecipient *)recipient;

- (id)initWithRecipientId:(NSNumber *)recipientId;

@end
