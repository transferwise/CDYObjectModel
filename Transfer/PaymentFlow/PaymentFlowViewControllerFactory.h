//
//  PaymentFlowViewControllerFactory.h
//  Transfer
//
//  Created by Juhan Hion on 12.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ObjectModel;

extern NSString * const kAllowProfileSwitch;
extern NSString * const kProfileIsExisting;
extern NSString * const kShowMiniProfile;
extern NSString * const kTemplateRecipient;
extern NSString * const kUpdateRecipient;
extern NSString * const kPayment;
extern NSString * const kPendingPayment;
extern NSString * const kPersonalProfileValidator;
extern NSString * const kRecipientProfileValidator;
extern NSString * const kBusinessProfileValidator;
extern NSString * const kPaymentValidator;
extern NSString * const kNextActionBlock;
extern NSString * const kValidationBlock;
extern NSString * const	kVerificationCompletionBlock;

typedef NS_ENUM(short, ControllerType)
{
	PersonalPaymentProfileController = 1,
	RecipientController = 2,
	BusinessPaymentProfileController = 3,
	ConfirmPaymentController = 4,
	PersonalProfileIdentificationController = 5,
	PaymentMethodSelectorController = 6,
	UploadMoneyController = 7,
	BusinessProfileIdentificationController = 8,
	RefundDetailsController = 9,
};

typedef void (^CommitActionBlock)(TRWActionBlock successBlock, TRWErrorBlock errorBlock);
typedef void (^PaymentValidationBlock)(TRWActionBlock validationBlock);
typedef void (^VerificationCompletionBlock)(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock, TRWErrorBlock errorBlock);

@interface PaymentFlowViewControllerFactory : NSObject

- (id)init __attribute__((unavailable("init unavailable, use initWithObjectModel")));

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel;

- (UIViewController *)getViewControllerWithType:(ControllerType)type
										 params:(NSDictionary *)params;

@end
