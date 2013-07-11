//
//  CreatePaymentOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "CurrencyPairsOperation.h"

@class PlainPayment;
@class PlainPaymentInput;

typedef void (^CreatePaymentBlock)(PlainPayment *payment, NSError *error);


@interface CreatePaymentOperation : TransferwiseOperation

@property (nonatomic, copy) CreatePaymentBlock responseHandler;

+ (CreatePaymentOperation *)commitOperationWithPayment:(PlainPaymentInput *)input;
+ (CreatePaymentOperation *)validateOperationWithInput:(PlainPaymentInput *)input;

@end
