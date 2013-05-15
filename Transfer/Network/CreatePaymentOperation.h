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

typedef void (^CreatePaymentBlock)(Payment *payment, NSError *error);


@interface CreatePaymentOperation : TransferwiseOperation

@property (nonatomic, copy) CreatePaymentBlock responseHandler;

- (void)setRecipientId:(NSNumber *)recipientId;
- (void)setSourceCurrency:(NSString *)sourceCurrency;
- (void)setTargetCurrency:(NSString *)targetCurrency;
- (void)setAmount:(NSString *)amount;
- (void)addReference:(NSString *)reference;
- (void)setEmail:(NSString *)email;

+ (CreatePaymentOperation *)operation;

@end
