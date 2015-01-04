//
//  PaymentFlowViewControllerFactory.m
//  Transfer
//
//  Created by Juhan Hion on 12.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentFlowViewControllerFactory.h"
#import "ObjectModel.h"
#import "PersonalPaymentProfileViewController.h"
#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "RecipientViewController.h"
#import "Credentials.h"
#import "BusinessPaymentProfileViewController.h"
#import "ConfirmPaymentViewController.h"
#import "PersonalProfileIdentificationViewController.h"
#import "PaymentMethodSelectorViewController.h"
#import "UploadMoneyViewController.h"
#import "BusinessProfileIdentificationViewController.h"
#import "RefundDetailsViewController.h"
#import "PersonalProfileValidation.h"
#import "BusinessProfileValidation.h"
#import "RecipientProfileValidation.h"
#import "PaymentValidation.h"
#import "NSObject+NSNull.h"

NSString * const kAllowProfileSwitch = @"allowProfileSwitch";
NSString * const kProfileIsExisting = @"profileIsExisting";
NSString * const kShowMiniProfile = @"showMiniProfile";
NSString * const kTemplateRecipient = @"templateRecipient";
NSString * const kUpdateRecipient = @"updateRecipient";
NSString * const kPayment = @"payment";
NSString * const kPendingPayment = @"pendingPayment";
NSString * const kPersonalProfileValidator = @"personalProfileValidator";
NSString * const kRecipientProfileValidator = @"recipientProfileValidator";
NSString * const kBusinessProfileValidator = @"businessProfileValidator";
NSString * const kPaymentValidator = @"paymentValidator";
NSString * const kNextActionBlock = @"nextActionBlock";
NSString * const kValidationBlock = @"validationBlock";

@interface PaymentFlowViewControllerFactory ()

@property (strong, nonatomic) ObjectModel *objectModel;

@end

@implementation PaymentFlowViewControllerFactory

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel
{
	self = [super init];
	if (self)
	{
		self.objectModel = objectModel;
	}
	return self;
}

- (UIViewController *)getViewControllerWithType:(ControllerType)type
										 params:(NSDictionary *)params
{
	switch (type)
	{
		case PersonalPaymentProfileController:
			return [self getPersonalProfileViewController:params[kAllowProfileSwitch]
											   isExisting:params[kProfileIsExisting]
								 personalProfileValidator:[NSObject getObjectOrNil:params[kPersonalProfileValidator]]];
			break;
		case RecipientController:
			return [self getRecipientViewController:params[kShowMiniProfile]
								  templateRecipient:[NSObject getObjectOrNil:params[kTemplateRecipient]]
									updateRecipient:[NSObject getObjectOrNil:params[kUpdateRecipient]]
						  recipientProfileValidator:[NSObject getObjectOrNil:params[kRecipientProfileValidator]]
									nextActionBlock:params[kNextActionBlock]];
			break;
		case BusinessPaymentProfileController:
			return [self getBusinessProfileViewController:[NSObject getObjectOrNil:params[kBusinessProfileValidator]]];
			break;
		case ConfirmPaymentController:
			return [self getConfirmPaymentViewController:[NSObject getObjectOrNil:params[kPaymentValidator]]
											successBlock:params[kNextActionBlock]];
			break;
		case PersonalProfileIdentificationController:
			return [self getPersonalProfileIdentificationViewController:[NSObject getObjectOrNil:params[kPendingPayment]]];
			break;
		case PaymentMethodSelectorController:
			return [self getPaymentMethodSelectorViewController:[NSObject getObjectOrNil:params[kPayment]]];
			break;
		case UploadMoneyController:
			return [self getUploadMoneyViewController:[NSObject getObjectOrNil:params[kPayment]]];
			break;
		case BusinessProfileIdentificationController:
			return [self getBusinessProfileIdentificationController:[NSObject getObjectOrNil:params[kPendingPayment]]];
			break;
		case RefundDetailsController:
			return [self getRefundDetailsViewController:[NSObject getObjectOrNil:params[kPendingPayment]]
										nextActionBlock:params[kNextActionBlock]];
			break;
		default:
			return nil;
			break;
	}
}

- (PersonalPaymentProfileViewController *)getPersonalProfileViewController:(BOOL)allowProfileSwitch
																isExisting:(BOOL)isExisting
												  personalProfileValidator:(id<PersonalProfileValidation>)personalProfileValidator
{
	PersonalPaymentProfileViewController *controller = [[PersonalPaymentProfileViewController alloc] init];
	
	[controller setObjectModel:self.objectModel];
	[controller setAllowProfileSwitch:allowProfileSwitch];
	[controller setIsExisting:isExisting];
	
	if (self.objectModel.pendingPayment.recipient)
	{
		[controller setButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
	}
	else
	{
		[controller setButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
	}
	
	[controller setProfileValidation:personalProfileValidator];
	
	return controller;
}

- (RecipientViewController *)getRecipientViewController:(BOOL)showMiniProfile
									  templateRecipient:(Recipient *)template
										updateRecipient:(Recipient *)updateRecipient
							  recipientProfileValidator:(id<RecipientProfileValidation>)recipientProfileValidator
										nextActionBlock:(TRWActionBlock)nextActionBlock
{
	RecipientViewController *controller = [[RecipientViewController alloc] init];
	if ([Credentials userLoggedIn])
	{
		[controller setReportingType:RecipientReportingLoggedIn];
	}
	else
	{
		[controller setReportingType:RecipientReportingNotLoggedIn];
	}
	[controller setObjectModel:self.objectModel];
	[controller setShowMiniProfile:showMiniProfile];
	[controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
	[controller setFooterButtonTitle:NSLocalizedString(@"button.title.continue", nil)];
	
	[controller setRecipientValidation:recipientProfileValidator];
	
	[controller setAfterSaveAction:^{
		nextActionBlock();
	}];
	
	if(template)
	{
		controller.templateRecipient = template;
	}
	if(updateRecipient)
	{
		controller.updateRecipient = updateRecipient;
	}
	
	[controller setPreLoadRecipientsWithCurrency:self.objectModel.pendingPayment.targetCurrency];
	
	return controller;
}

- (BusinessPaymentProfileViewController *)getBusinessProfileViewController:(id<BusinessProfileValidation>)businessProfileValidator
{
	BusinessPaymentProfileViewController *controller = [[BusinessPaymentProfileViewController alloc] init];
	
	[controller setObjectModel:self.objectModel];
	[controller setButtonTitle:NSLocalizedString(@"business.profile.confirm.payment.button.title", nil)];
	
	[controller setProfileValidation:businessProfileValidator];
	
	return controller;
}

- (ConfirmPaymentViewController *)getConfirmPaymentViewController:(id<PaymentValidation>)paymentValidator
													 successBlock:(TRWActionBlock)successBlock;
{
	ConfirmPaymentViewController *controller = [[ConfirmPaymentViewController alloc] init];
	if ([Credentials userLoggedIn])
	{
		[controller setReportingType:ConfirmPaymentReportingLoggedIn];
	}
	else
	{
		[controller setReportingType:ConfirmPaymentReportingNotLoggedIn];
	}
	
	[controller setObjectModel:self.objectModel];
	[controller setPayment:[self.objectModel pendingPayment]];
	[controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
	[controller setPaymentValidator:paymentValidator];
	[controller setSucessBlock:successBlock];
	
	return controller;
}

- (PersonalProfileIdentificationViewController *)getPersonalProfileIdentificationViewController:(PendingPayment *)payment
{
	PersonalProfileIdentificationViewController *controller = [[PersonalProfileIdentificationViewController alloc] init];
	[controller setObjectModel:self.objectModel];
	
	[controller setIdentificationRequired:(IdentificationRequired) [payment verificiationNeededValue]];
	[controller setProposedPaymentPurpose:[payment proposedPaymentsPurpose]];
	[controller setCompletionMessage:NSLocalizedString(@"identification.creating.payment.message", nil)];
	__weak typeof(self) weakSelf = self;
	
	[controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock, TRWErrorBlock errorBlock) {
		[weakSelf.objectModel performBlock:^{
			//TODO: SSN
			[payment setSendVerificationLaterValue:skipIdentification];
			[payment setPaymentPurpose:paymentPurpose];
			[payment setSocialSecurityNumber:socialSecurityNumber];
			
			[weakSelf.objectModel saveContext:^{
				weakSelf.commitActionBlock(successBlock, errorBlock);
			}];
		}];
	}];
	
	return controller;
}

- (PaymentMethodSelectorViewController *)getPaymentMethodSelectorViewController:(Payment *)payment
{
	PaymentMethodSelectorViewController* controller = [[PaymentMethodSelectorViewController alloc] init];
	controller.objectModel = self.objectModel;
	controller.payment = payment;
	
	return controller;
}

- (UploadMoneyViewController *)getUploadMoneyViewController:(Payment *)payment
{
	UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
	controller.objectModel = self.objectModel;
	controller.payment = payment;
	
	return controller;
}

- (BusinessProfileIdentificationViewController *)getBusinessProfileIdentificationController:(PendingPayment *)payment
{
	BusinessProfileIdentificationViewController *controller = [[BusinessProfileIdentificationViewController alloc] init];
	__weak typeof(self) weakSelf = self;
	
	[controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock,TRWErrorBlock errorBlock) {
		[weakSelf.objectModel performBlock:^{
			[payment setSendVerificationLaterValue:skipIdentification];
			[weakSelf.objectModel saveContext:^{
				weakSelf.commitActionBlock(successBlock, errorBlock);
			}];
		}];
	}];
	
	return controller;
}

- (RefundDetailsViewController *)getRefundDetailsViewController:(PendingPayment *)payment
												nextActionBlock:(TRWActionBlock)nextActionBlock
{
	RefundDetailsViewController *controller = [[RefundDetailsViewController alloc] init];
	[controller setObjectModel:self.objectModel];
	[controller setCurrency:payment.sourceCurrency];
	[controller setPayment:payment];
	[controller setAfterValidationBlock:^{
		nextActionBlock();
	}];
	
	return controller;
}

@end
