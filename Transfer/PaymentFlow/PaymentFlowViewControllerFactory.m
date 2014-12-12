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

@interface PaymentFlowViewControllerFactory ()

@property (strong, nonatomic) ObjectModel *objectModel;
@property (copy, nonatomic) TRWActionBlock nextActionBlock;
@property (copy, nonatomic) CommitActionBlock commitActionBlock;

@end

@implementation PaymentFlowViewControllerFactory

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel
						 nextAction:(TRWActionBlock)nextActionBlock
					   commitAction:(CommitActionBlock)commitActionBlock
{
	self = [super init];
	if (self)
	{
		self.objectModel = objectModel;
		self.nextActionBlock = nextActionBlock;
		self.commitActionBlock = commitActionBlock;
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
											   isExisting:params[kProfileIsExisting]];
			break;
		case RecipientController:
			return [self getRecipientViewController:params[kShowMiniProfile]
								  templateRecipient:params[kTemplateRecipient]
									updateRecipient:params[kUpdateRecipient]];
			break;
		case BusinessPaymentProfileController:
			return [self getBusinessProfileViewController];
			break;
		case ConfirmPaymentController:
			return [self getConfirmPaymentViewController];
			break;
		case PersonalProfileIdentificationController:
			return [self getPersonalProfileIdentificationViewController:params[kPendingPayment]];
			break;
		case PaymentMethodSelectorController:
			return [self getPaymentMethodSelectorViewController:params[kPayment]];
			break;
		case UploadMoneyController:
			return [self getUploadMoneyViewController:params[kPayment]];
			break;
		case BusinessProfileIdentificationController:
			return [self getBusinessProfileIdentificationController:params[kPendingPayment]];
			break;
		case RefundDetailsController:
			return [self getRefundDetailsViewController:params[kPendingPayment]];
			break;
		default:
			return nil;
			break;
	}
}

- (PersonalPaymentProfileViewController *)getPersonalProfileViewController:(BOOL)allowProfileSwitch
																isExisting:(BOOL)isExisting
{
	PersonalPaymentProfileViewController *controller = [[PersonalPaymentProfileViewController alloc] init];
	
	[controller setObjectModel:self.objectModel];
	[controller setAllowProfileSwitch:allowProfileSwitch];
	[controller setIsExisting:isExisting];
	
	if (self.objectModel.pendingPayment.recipient)
	{
		[controller setButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
	} else
	{
		[controller setButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
	}
	
	//TODO: use validation with a provider
	//[controller setProfileValidation:self];
	
	return controller;
}

- (RecipientViewController *)getRecipientViewController:(BOOL)showMiniProfile
									  templateRecipient:(Recipient *)template
										updateRecipient:(Recipient *)updateRecipient
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
	
	//TODO: use validation with provider
//	[controller setRecipientValidation:self];
	__weak typeof(self) weakSelf = self;
	[controller setAfterSaveAction:^{
		weakSelf.nextActionBlock();
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

- (BusinessPaymentProfileViewController *)getBusinessProfileViewController
{
	BusinessPaymentProfileViewController *controller = [[BusinessPaymentProfileViewController alloc] init];
	
	[controller setObjectModel:self.objectModel];
	[controller setButtonTitle:NSLocalizedString(@"business.profile.confirm.payment.button.title", nil)];
	
	//TODO: use validation with provider
//	[controller setProfileValidation:self];
	
	return controller;
}

- (ConfirmPaymentViewController *)getConfirmPaymentViewController
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
	//TODO: use this with block
	//[controller setPaymentFlow:self];
	
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
{
	RefundDetailsViewController *controller = [[RefundDetailsViewController alloc] init];
	[controller setObjectModel:self.objectModel];
	[controller setCurrency:payment.sourceCurrency];
	[controller setPayment:payment];
	__weak typeof(self) weakSelf = self;
	[controller setAfterValidationBlock:^{
		weakSelf.nextActionBlock();
	}];
	
	return controller;
}

@end
