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

@class ObjectModel;

typedef void (^VerificationStepSuccessBlock)(void);
typedef void (^PaymentErrorBlock)(NSError *error);
typedef void (^EmailValidationResultBlock)(BOOL available, NSError *error);

@interface PaymentFlow : NSObject <PersonalProfileValidation, RecipientProfileValidation, BusinessProfileValidation>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) PaymentErrorBlock paymentErrorHandler;
@property (nonatomic, copy) VerificationStepSuccessBlock verificationSuccessBlock;

- (id)initWithPresentingController:(UINavigationController *)controller;

- (void)verifyEmail:(NSString *)email
	withResultBlock:(EmailValidationResultBlock)resultBlock;

- (void)validatePayment:(NSManagedObjectID *)paymentInput
		   successBlock:(VerificationStepSuccessBlock)successBlock
		   errorHandler:(PaymentErrorBlock)errorHandler;

- (void)commitPaymentWithSuccessBlock:(VerificationStepSuccessBlock)successBlock
						 ErrorHandler:(PaymentErrorBlock)errorHandler;

- (void)presentPersonalProfileEntry:(BOOL)allowProfileSwitch
						 isExisting:(BOOL)isExisting;

- (void)presentRecipientDetails:(BOOL)showMiniProfile;

- (void)presentPaymentConfirmation;
- (void)registerUser;
- (void)presentRefundAccountViewController;
- (void)handleNextStepOfPendingPaymentCommit;
- (void)presentNextPaymentScreen;

@end