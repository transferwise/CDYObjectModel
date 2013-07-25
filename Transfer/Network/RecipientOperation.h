//
//  RecipientOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^RecipientResponseBlock)(NSError *error);

@interface RecipientOperation : TransferwiseOperation

@property (nonatomic, copy) RecipientResponseBlock responseHandler;

+ (RecipientOperation *)createOperationWithRecipient:(NSManagedObjectID *)recipient;
+ (RecipientOperation *)validateOperationWithRecipient:(NSManagedObjectID *)recipient;

@end
