//
//  CreatePaymentOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "CurrencyPairsOperation.h"

@class Payment;
@class PaymentInput;

typedef void (^CreatePaymentBlock)(Payment *payment, NSError *error);


@interface CreatePaymentOperation : TransferwiseOperation

@property (nonatomic, copy) CreatePaymentBlock responseHandler;

+ (CreatePaymentOperation *)operation;
+ (CreatePaymentOperation *)validateOperationWithInput:(PaymentInput *)input;

@end
