//
//  PaymentFlow.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalProfileValidation.h"
#import "RecipientProfileValidation.h"
#import "BusinessProfileValidation.h"

@class ProfileDetails;
@class Currency;
@class RecipientType;
@class CalculationResult;
@class Recipient;
@class PaymentInput;
@class PaymentVerificationRequired;
@class BusinessProfileInput;

typedef void (^PaymentErrorBlock)(NSError *error);

@interface PaymentFlow : NSObject <PersonalProfileValidation, RecipientProfileValidation, BusinessProfileValidation>

@property (nonatomic, strong) Currency *sourceCurrency;
@property (nonatomic, strong) Currency *targetCurrency;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) ProfileDetails *userDetails;

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;
- (void)validatePayment:(PaymentInput *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler;
- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler;

@end
