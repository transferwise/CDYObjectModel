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

@class PlainProfileDetails;
@class PlainRecipientType;
@class CalculationResult;
@class PlainRecipient;
@class PlainPaymentInput;
@class PlainPaymentVerificationRequired;
@class PlainBusinessProfileInput;
@class ObjectModel;

typedef void (^PaymentErrorBlock)(NSError *error);

@interface PaymentFlow : NSObject <PersonalProfileValidation, RecipientProfileValidation, BusinessProfileValidation>

@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, strong) PlainRecipient *recipient;
@property (nonatomic, strong) PlainProfileDetails *userDetails;
@property (nonatomic, strong) ObjectModel *objectModel;

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;
- (void)validatePayment:(PlainPaymentInput *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler;
- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler;

@end
