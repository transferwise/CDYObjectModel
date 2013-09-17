//
//  PullPaymentDetailsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^PullPaymentResponseBlock)(NSError *error);

@interface PullPaymentDetailsOperation : TransferwiseOperation

@property (nonatomic, copy) PullPaymentResponseBlock resultHandler;

+ (PullPaymentDetailsOperation *)operationWithPaymentId:(NSNumber *)paymentId;

@end
