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

const NSString *kAllowProfileSwitch = @"allowProfileSwitch";
const NSString *kProfileIsExisting = @"profileIsExisting";
const NSString *kShowMiniProfile = @"showMiniProfile";
const NSString *kTemplateRecipient = @"templateRecipient";
const NSString *kUpdateRecipient = @"updateRecipient";
const NSString *kPayment = @"payment";
const NSString *kPendingPayment = @"pendingPayment";
const NSString *kPersonalProfileValidator = @"personalProfileValidator";
const NSString *kRecipientProfileValidator = @"recipientProfileValidator";
const NSString *kBusinessProfileValidator = @"businessProfileValidator";
const NSString *kPaymentValidator = @"paymentValidator";
const NSString *kNextActionBlock = @"nextActionBlock";

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

@interface PaymentFlowViewControllerFactory : NSObject

@property (copy, nonatomic) CommitActionBlock commitActionBlock;

- (id)init __attribute__((unavailable("init unavailable, use initWithObjectModel")));

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel;

- (UIViewController *)getViewControllerWithType:(ControllerType)type
										 params:(NSDictionary *)params;

@end
