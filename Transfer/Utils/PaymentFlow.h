//
//  PaymentFlow.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileDetails;
@class Currency;
@class RecipientType;
@class CalculationResult;
@class Recipient;
@class PaymentInput;
@class PaymentVerificationRequired;

typedef void (^PaymentErrorBlock)(NSError *error);

@interface PaymentFlow : NSObject

@property (nonatomic, strong) Currency *sourceCurrency;
@property (nonatomic, strong) Currency *targetCurrency;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, strong) Recipient *recipient;

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;
- (void)validatePayment:(PaymentInput *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler;
- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler;

@end
