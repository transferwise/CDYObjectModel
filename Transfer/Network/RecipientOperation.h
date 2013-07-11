//
//  RecipientOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@class PlainRecipient;
@class PlainRecipientProfileInput;

typedef void (^RecipientResponseBlock)(PlainRecipient *recipient, NSError *error);

@interface RecipientOperation : TransferwiseOperation

@property (nonatomic, copy) RecipientResponseBlock responseHandler;

+ (RecipientOperation *)createOperationWithRecipient:(PlainRecipientProfileInput *)recipient;
+ (RecipientOperation *)validateOperationWithRecipient:(PlainRecipientProfileInput *)recipient;

@end
