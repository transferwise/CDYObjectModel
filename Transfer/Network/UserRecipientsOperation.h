//
//  UserRecipientsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "RecipientsOperation.h"

@class Currency;

@interface UserRecipientsOperation : RecipientsOperation

+ (UserRecipientsOperation *)recipientsOperation;
+ (UserRecipientsOperation *)recipientsOperationWithCurrency:(Currency *)currency;

@end
