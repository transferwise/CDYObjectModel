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
#import "NSObject+NSNull.h"
#import "Currency.h"
#import "CustomInfoViewController+NoPayInMethods.h"

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
NSString * const kNextActionBlock = @"nextActionBlock";
NSString * const kValidationBlock = @"validationBlock";
NSString * const kVerificationCompletionBlock = @"verificationCompletionBlock";

@interface PaymentFlowViewControllerFactory ()

@property (strong, nonatomic) ObjectModel *objectModel;

@end

@implementation PaymentFlowViewControllerFactory

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel
{
	NSAssert(objectModel, @"object model is nil");
	
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
			return [self getPersonalProfileViewController:[[params objectForKey:kAllowProfileSwitch] boolValue]
											   isExisting:[[params objectForKey:kProfileIsExisting] boolValue]
								 personalProfileValidator:[NSObject getObjectOrNil:params[kPersonalProfileValidator]]];
			break;
		case RecipientController:
			return [self getRecipientViewController:[[params objectForKey:kShowMiniProfile] boolValue]
								  templateRecipient:[NSObject getObjectOrNil:params[kTemplateRecipient]]
									updateRecipient:[NSObject getObjectOrNil:params[kUpdateRecipient]]
						  recipientProfileValidator:[NSObject getObjectOrNil:params[kRecipientProfileValidator]]
									nextActionBlock:[NSObject getObjectOrNil:params[kNextActionBlock]]];
			break;
		case BusinessPaymentProfileController:
			return [self getBusinessProfileViewController:[NSObject getObjectOrNil:params[kBusinessProfileValidator]]];
			break;
		case ConfirmPaymentController:
			return [self getConfirmPaymentViewController:[NSObject getObjectOrNil:params[kNextActionBlock]]];
			break;
		case PersonalProfileIdentificationController:
			return [self getPersonalProfileIdentificationViewController:[NSObject getObjectOrNil:params[kPendingPayment]]
															 completion:[NSObject getObjectOrNil:params[kVerificationCompletionBlock]]];
			break;
		case PaymentMethodSelectorController:
			return [self getPaymentMethodSelectorViewController:[NSObject getObjectOrNil:params[kPayment]]];
			break;
		case UploadMoneyController:
			return [self getUploadMoneyViewController:[NSObject getObjectOrNil:params[kPayment]]];
			break;
		case BusinessProfileIdentificationController:
			return [self getBusinessProfileIdentificationController:[NSObject getObjectOrNil:params[kPendingPayment]]
														 completion:[NSObject getObjectOrNil:params[kVerificationCompletionBlock]]];
			break;
		case RefundDetailsController:
			return [self getRefundDetailsViewController:[NSObject getObjectOrNil:params[kPendingPayment]]
										nextActionBlock:[NSObject getObjectOrNil:params[kNextActionBlock]]];
			break;
		default:
			return nil;
			break;
	}
}

-(TransparentModalViewController *)getCustomModalWithType:(ModalType)type params:(NSDictionary *)params
{
    switch (type) {
        case NoPayInMethodsFailModal:
            return [self getNoPayInMethodsViewController:[NSObject getObjectOrNil:params[kPayment]]];
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
	NSAssert(personalProfileValidator, @"personal profile validator is nil");
	
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
	NSAssert(recipientProfileValidator, @"recipient profile validator is nil");
	NSAssert(nextActionBlock, @"next action block is nil");
	
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
	NSAssert(businessProfileValidator, @"business profile validator is nil");
	
	BusinessPaymentProfileViewController *controller = [[BusinessPaymentProfileViewController alloc] init];
	
	[controller setObjectModel:self.objectModel];
	[controller setButtonTitle:NSLocalizedString(@"business.profile.confirm.payment.button.title", nil)];
	
	[controller setProfileValidation:businessProfileValidator];
	
	return controller;
}

- (ConfirmPaymentViewController *)getConfirmPaymentViewController:(TRWActionBlock)successBlock;
{
	NSAssert(successBlock, @"sucess block is nil");
	
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
	[controller setSucessBlock:successBlock];
	
	return controller;
}

- (PersonalProfileIdentificationViewController *)getPersonalProfileIdentificationViewController:(PendingPayment *)payment
																					 completion:(VerificationCompletionBlock)completion
{
	NSAssert(payment, @"pending payment is nil");
	NSAssert(completion, @"completion block is nil");
	
	PersonalProfileIdentificationViewController *controller = [[PersonalProfileIdentificationViewController alloc] init];
	[controller setObjectModel:self.objectModel];
	
	[controller setIdentificationRequired:(IdentificationRequired) [payment verificiationNeededValue]];
	[controller setProposedPaymentPurpose:[payment proposedPaymentsPurpose]];
     controller.driversLicenseFirst = [@"usd" caseInsensitiveCompare:payment.sourceCurrency.code] == NSOrderedSame;
	[controller setCompletionMessage:NSLocalizedString(@"identification.creating.payment.message", nil)];
	[controller setCompletionHandler:completion];
	
	return controller;
}

- (PaymentMethodSelectorViewController *)getPaymentMethodSelectorViewController:(Payment *)payment
{
	NSAssert(payment, @"payment is nil");
	
	PaymentMethodSelectorViewController* controller = [[PaymentMethodSelectorViewController alloc] init];
	controller.objectModel = self.objectModel;
	controller.payment = payment;
	
	return controller;
}

- (UploadMoneyViewController *)getUploadMoneyViewController:(Payment *)payment
{
	NSAssert(payment, @"payment is nil");
	
	UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
	controller.objectModel = self.objectModel;
	controller.payment = payment;
	
	return controller;
}

- (BusinessProfileIdentificationViewController *)getBusinessProfileIdentificationController:(PendingPayment *)payment
																				 completion:(VerificationCompletionBlock)completion
{
	NSAssert(payment, @"payment is nil");
	NSAssert(completion, @"completion block is nil");
	
	BusinessProfileIdentificationViewController *controller = [[BusinessProfileIdentificationViewController alloc] init];
	[controller setCompletionHandler:completion];
	
	return controller;
}

- (RefundDetailsViewController *)getRefundDetailsViewController:(PendingPayment *)payment
												nextActionBlock:(TRWActionBlock)nextActionBlock
{
	NSAssert(payment, @"payment is nil");
	NSAssert(nextActionBlock, @"next action block is nil");
	
	RefundDetailsViewController *controller = [[RefundDetailsViewController alloc] init];
	[controller setObjectModel:self.objectModel];
	[controller setCurrency:payment.sourceCurrency];
	[controller setPayment:payment];
	[controller setAfterValidationBlock:^{
		nextActionBlock();
	}];
	
	return controller;
}

- (CustomInfoViewController *)getNoPayInMethodsViewController:(Payment *)payment
{
    NSAssert(payment, @"payment is nil");
    CustomInfoViewController* controller = [CustomInfoViewController failScreenNoPayInMethodsForCurrency:payment.sourceCurrency];
    controller.actionButtonBlock = ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    };
    
    return controller;
}


@end
