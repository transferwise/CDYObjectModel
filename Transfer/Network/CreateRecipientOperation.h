//
//  CreateRecipientOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@class Recipient;

typedef void (^RecipientResponseBlock)(Recipient *recipient, NSError *error);

@interface CreateRecipientOperation : TransferwiseOperation

@property (nonatomic, copy) RecipientResponseBlock responseHandler;

+ (CreateRecipientOperation *)operationWithRecipient:(Recipient *)recipient;

@end
