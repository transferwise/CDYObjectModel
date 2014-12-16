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
#import "Constants.h"
#import "PaymentFlowViewControllerFactory.h"
#import "ValidatorFactory.h"

@class ObjectModel;

//TODO: remove and use validator
typedef void (^EmailValidationResultBlock)(BOOL available, NSError *error);

@interface PaymentFlow : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) TRWErrorBlock paymentErrorHandler;
@property (nonatomic, copy) TRWActionBlock verificationSuccessBlock;

- (id)initWithPresentingController:(UINavigationController *)controller
  paymentFlowViewControllerFactory:(PaymentFlowViewControllerFactory *)controllerFactory
				  validatorFactory:(ValidatorFactory *)validatorFactory;

//TODO: remove and use validator
- (void)verifyEmail:(NSString *)email
	withResultBlock:(EmailValidationResultBlock)resultBlock;

- (void)validatePayment:(NSManagedObjectID *)paymentInput
		   successBlock:(TRWActionBlock)successBlock
		   errorHandler:(TRWErrorBlock)errorHandler;

- (void)commitPaymentWithSuccessBlock:(TRWActionBlock)successBlock
						 errorHandler:(TRWErrorBlock)errorHandler;

- (void)presentPersonalProfileEntry:(BOOL)allowProfileSwitch
						 isExisting:(BOOL)isExisting;

- (void)presentRecipientDetails:(BOOL)showMiniProfile;

- (void)presentPaymentConfirmation;
- (void)registerUser;
- (void)presentRefundAccountViewController;
- (void)handleNextStepOfPendingPaymentCommit;
- (void)presentNextPaymentScreen;

@end