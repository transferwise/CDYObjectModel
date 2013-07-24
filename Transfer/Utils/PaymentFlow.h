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

@class PlainPaymentVerificationRequired;
@class ObjectModel;

typedef void (^PaymentErrorBlock)(NSError *error);

@interface PaymentFlow : NSObject <PersonalProfileValidation, RecipientProfileValidation, BusinessProfileValidation>

@property (nonatomic, strong) ObjectModel *objectModel;

- (id)initWithPresentingController:(UINavigationController *)controller;
- (void)presentSenderDetails;
- (void)validatePayment:(NSManagedObjectID *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler;
- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler;

@end
