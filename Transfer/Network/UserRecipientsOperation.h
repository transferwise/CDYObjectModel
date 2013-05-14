//
//  UserRecipientsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@class Currency;

typedef void (^ListRecipientsBlock)(NSArray *recipients, NSError *error);

@interface UserRecipientsOperation : TransferwiseOperation

@property (nonatomic, copy) ListRecipientsBlock responseHandler;

+ (UserRecipientsOperation *)recipientsOperation;
+ (UserRecipientsOperation *)recipientsOperationWithCurrency:(Currency *)currency;

@end
