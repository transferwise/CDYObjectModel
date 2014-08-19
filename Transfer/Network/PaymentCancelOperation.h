//
//  PaymentcancelOperation.h
//  Transfer
//
//  Created by Mats Trovik on 18/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
@class Payment;

typedef void (^PaymentCancelBlock)(NSError *error);

@interface PaymentCancelOperation : TransferwiseOperation

@property (nonatomic, copy) PaymentCancelBlock responseHandler;

+ (instancetype)operationWithPayment:(Payment *)payment;
- (instancetype)initWithPaymentId:(NSNumber *)paymentId;

@end
