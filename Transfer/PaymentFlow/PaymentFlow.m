//
//  PaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentFlow.h"
#import "CreatePaymentOperation.h"
#import "VerificationRequiredOperation.h"
#import "Credentials.h"
#import "UploadVerificationFileOperation.h"
#import "PersonalProfileOperation.h"
#import "EmailCheckOperation.h"
#import "RecipientOperation.h"
#import "BusinessProfileOperation.h"
#import "TRWAlertView.h"
#import "ObjectModel.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"
#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "Currency.h"
#import "Recipient.h"
#import "PaymentPurposeOperation.h"
#import "UploadMoneyViewController.h"
#import "GoogleAnalytics.h"
#import "AppsFlyerTracker.h"
#import "CalculationResult.h"
#import "LoggedInPaymentFlow.h"
#import "NanTracking.h"
#import "FBAppEvents.h"
#import "NetworkErrorCodes.h"
#import "_RecipientType.h"
#import "RecipientType.h"
#import "RefundDetailsViewController.h"
#import "Mixpanel.h"
#import "Mixpanel+Customisation.h"
#import "GoogleAnalytics.h"
#import "RegisterOperation.h"
#import "SetSSNOperation.h"
#import "EventTracker.h"
#import "ObjectModel+Payments.h"
#import "EmailValidation.h"
#import "NSObject+NSNull.h"
#import "ConfirmPaymentViewController.h"
#import "TransparentModalViewController.h"

#define	PERSONAL_PROFILE	@"personal"
#define BUSINESS_PROFILE	@"business"

#define kProgressRecipient 0.4f
#define kProgressPersonalProfile 0.6f
#define kProgressBusinessProfile 0.7f
#define kProgressRefundRecipient 0.8f
#define kProgressConfirm 1.0f

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) PaymentFlowViewControllerFactory *controllerFactory;
@property (nonatomic, strong) ValidatorFactory *validatorFactory;

@end

@implementation PaymentFlow

- (id)initWithPresentingController:(UINavigationController *)controller
  paymentFlowViewControllerFactory:(PaymentFlowViewControllerFactory *)controllerFactory
				  validatorFactory:(ValidatorFactory *)validatorFactory
{
    self = [super init];

    if (self)
	{
        _navigationController = controller;
		_controllerFactory = controllerFactory;
		_validatorFactory = validatorFactory;    }

    return self;
}

- (void)presentPersonalProfileEntry:(BOOL)allowProfileSwitch
						 isExisting:(BOOL)isExisting
{
    PendingPayment *pendingPayment = self.objectModel.pendingPayment;
    if(pendingPayment)
    {
        [[Mixpanel sharedInstance] sendPageView:MPYourDetails withProperties:[pendingPayment trackingProperties]];
    }

	id<PersonalProfileValidation> validator = [self.validatorFactory getValidatorWithType:ValidatePersonalProfile];
	
	__weak typeof(self) weakSelf = self;
	[validator setSuccessBlock:^{
		[weakSelf presentNextPaymentScreen];
	}];
	
	[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:PersonalPaymentProfileController
																							 params:@{kAllowProfileSwitch: [NSNumber numberWithBool:allowProfileSwitch],
																									  kProfileIsExisting: [NSNumber numberWithBool:isExisting],
																									  kPersonalProfileValidator: [NSObject getObjectOrNsNull:validator]}]
										 animated:YES];
}

- (void)presentRecipientDetails:(BOOL)showMiniProfile
{
    [self presentRecipientDetails:showMiniProfile
				templateRecipient:nil];
}

- (void)presentRecipientDetails:(BOOL)showMiniProfile
			  templateRecipient:(Recipient*)template
{
    [self presentRecipientDetails:showMiniProfile
				templateRecipient:template
				  updateRecipient:nil];
}

- (void)presentRecipientDetails:(BOOL)showMiniProfile
				updateRecipient:(Recipient*)updateRecipient
{
    [self presentRecipientDetails:showMiniProfile
				templateRecipient:nil
				  updateRecipient:updateRecipient];
}

- (void)presentRecipientDetails:(BOOL)showMiniProfile
			  templateRecipient:(Recipient*)template
				updateRecipient:(Recipient*)updateRecipient
{
    [[GoogleAnalytics sharedInstance] paymentRecipientProfileScreenShown];
    [[Mixpanel sharedInstance] sendPageView:GASelectRecipient withProperties:[self.objectModel.pendingPayment trackingProperties]];
	
    if([self isAZOrOK])
    {
        return;
    }
    
	__weak typeof(self) weakSelf = self;
	id<RecipientProfileValidation> validator = [self.validatorFactory getValidatorWithType:ValidateRecipientProfile];
	TRWActionBlock nextBlock = ^{
		[weakSelf presentNextPaymentScreen];
	};
    
	[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:RecipientController
																							 params:@{kShowMiniProfile: [NSNumber numberWithBool:showMiniProfile],
																									  kTemplateRecipient: [NSObject getObjectOrNsNull:template],
																									  kUpdateRecipient: [NSObject getObjectOrNsNull:updateRecipient],
																									  kRecipientProfileValidator: [NSObject getObjectOrNsNull:validator],
																									  kNextActionBlock: [nextBlock copy]}]
										 animated:YES];
}

- (void)presentNextScreenAfterRecipientDetails
{
    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel pendingPayment];
        if ([payment.user personalProfileFilled]) {
            [self presentPaymentConfirmation];
        } else {
            [self presentPersonalProfileEntry:YES
								   isExisting:NO];
        }
    }];
}

- (void)presentBusinessProfileScreen
{
	dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentBusinessProfileScreen");
		
		__weak typeof(self) weakSelf = self;
		id<BusinessProfileValidation> validator = [self.validatorFactory getValidatorWithType:ValidateBusinessProfile];
		
		[validator setSuccessBlock:^{
			[weakSelf presentNextPaymentScreen];
		}];
		
		[validator setPersonalProfileNotFilledBlock:^{
			//TODO jaanus: this class should not show anything on screen
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.needed.popup.title", nil) message:NSLocalizedString(@"personal.profile.needed.popup.message", nil)];
			[alertView setLeftButtonTitle:NSLocalizedString(@"button.title.fill", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];
			
			[alertView setLeftButtonAction:^{
				[weakSelf presentPersonalProfileEntry:NO
										   isExisting:NO];
			}];
			
			[alertView show];
		}];
		
		[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:BusinessPaymentProfileController
																								 params:@{kBusinessProfileValidator: [NSObject getObjectOrNsNull:validator]}]
											 animated:YES];
    });
}

- (void)presentPaymentConfirmation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentPaymentConfirmation");
		
		__weak typeof(self) weakSelf = self;
		
		TRWActionBlock successBlock = ^{
            [weakSelf updateSenderProfile:^{
                [weakSelf checkVerificationNeeded];
            }];
		};
		
		
		//TODO: decouple validation error handling to get rid of this
		ConfirmPaymentViewController *controller = (ConfirmPaymentViewController *)[self.controllerFactory getViewControllerWithType:ConfirmPaymentController
																							  params:@{kNextActionBlock: [successBlock copy]}];
		
		self.paymentErrorHandler = ^(NSError *error) {
			[controller handleValidationError:error];
		};
		
		[self.navigationController pushViewController:controller
											 animated:YES];
    });
}

- (void)presentVerificationScreen
{
    [[GoogleAnalytics sharedInstance] sendScreen:GAPersonalIdentification];
	
	PendingPayment *payment = [self.objectModel pendingPayment];
	
	__weak typeof(self) weakSelf = self;
	VerificationCompletionBlock completion = ^(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock, TRWErrorBlock errorBlock) {
		[weakSelf.objectModel performBlock:^{
			//TODO: SSN
			[payment setSendVerificationLaterValue:skipIdentification];
			[payment setPaymentPurpose:paymentPurpose];
			[payment setSocialSecurityNumber:socialSecurityNumber];
			
			[weakSelf.objectModel saveContext:^{
				[weakSelf commitPaymentWithSuccessBlock:successBlock errorHandler:errorBlock];
			}];
		}];
	};
	
	[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:PersonalProfileIdentificationController
																							 params:@{kPendingPayment: [NSObject getObjectOrNsNull:payment],
																									  kVerificationCompletionBlock: [completion copy]}]
										 animated:YES];
}

- (void)presentUploadMoneyController:(NSManagedObjectID *)paymentID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentUploadMoneyController");
        if ([self isKindOfClass:[LoggedInPaymentFlow class]])
		{
            [[GoogleAnalytics sharedInstance] sendPaymentEvent:GAPaymentcreated withLabel:@"logged"];
        }
		else
		{
            [[GoogleAnalytics sharedInstance] sendPaymentEvent:GAPaymentcreated withLabel:@"not logged"];
        }
        
        Payment* payment = (id) [self.objectModel.managedObjectContext objectWithID:paymentID];
        
        
        NSUInteger numberOfPayInMethods = [[payment enabledPayInMethods] count];
        if(numberOfPayInMethods < 1)
        {
            TransparentModalViewController* failModal = [self.controllerFactory getCustomModalWithType:NoPayInMethodsFailModal params:@{kPayment: [NSObject getObjectOrNsNull:payment]}];
            [failModal presentOnViewController:self.navigationController.parentViewController];
        }
        else if(!IPAD && (numberOfPayInMethods > 2 || ([@"usd" caseInsensitiveCompare:[payment.sourceCurrency.code lowercaseString]] == NSOrderedSame && numberOfPayInMethods > 1)))
        {
			[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:PaymentMethodSelectorController
																									 params:@{kPayment: [NSObject getObjectOrNsNull:payment]}]
												 animated:YES];
        }
        else
        {
			[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:UploadMoneyController
																									 params:@{kPayment: [NSObject getObjectOrNsNull:payment]}]
												 animated:YES];
        }
        
    });
}

- (void)checkVerificationNeeded
{
    MCLog(@"checkVerificationNeeded");
    VerificationRequiredOperation *operation = [VerificationRequiredOperation operation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;
    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                weakSelf.paymentErrorHandler(error);
                return;
            }

            PendingPayment *pendingPayment = [weakSelf.objectModel pendingPayment];
            MCLog(@"Any verification required? %d", pendingPayment.isAnyVerificationRequired);
            MCLog(@"Logged in? %d", [Credentials userLoggedIn]);
            if ([pendingPayment isAnyVerificationRequired] && [[pendingPayment profileUsed] isEqualToString:@"business"])
			{
                if(weakSelf.verificationSuccessBlock)
                {
                    weakSelf.verificationSuccessBlock();
                    weakSelf.verificationSuccessBlock = nil;
                }
                [weakSelf presentBusinessVerificationScreen];
            }
			else if ([pendingPayment isAnyVerificationRequired])
			{
                MCLog(@"Present verification screen");
                if(weakSelf.verificationSuccessBlock)
                {
                    weakSelf.verificationSuccessBlock();
                    weakSelf.verificationSuccessBlock = nil;
                }
                [weakSelf presentVerificationScreen];
            }
			else if ([Credentials userLoggedIn])
			{
                MCLog(@"Update sender profile");
                [weakSelf updateSenderProfile:^{
                    [weakSelf handleNextStepOfPendingPaymentCommit];
                }];
            }
			else
			{
                MCLog(@"Register user");
                [weakSelf registerUser];
            }
        });
    }];

    [operation execute];
}

- (void)presentBusinessVerificationScreen
{
    [[GoogleAnalytics sharedInstance] sendScreen:GABusinessVerification];
	
	PendingPayment *payment = [self.objectModel pendingPayment];
	__weak typeof(self) weakSelf = self;
	VerificationCompletionBlock completion = ^(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock,TRWErrorBlock errorBlock) {
		[weakSelf.objectModel performBlock:^{
			[payment setSendVerificationLaterValue:skipIdentification];
			[weakSelf.objectModel saveContext:^{
				[weakSelf commitPaymentWithSuccessBlock:successBlock errorHandler:errorBlock];
			}];
		}];
	};

	[self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:BusinessProfileIdentificationController
																							 params:@{kPendingPayment: [NSObject getObjectOrNsNull:payment],
																									  kVerificationCompletionBlock: [completion copy]}]
										 animated:YES];
}

- (void)commitPaymentWithSuccessBlock:(TRWActionBlock)successBlock
						 errorHandler:(TRWErrorBlock)errorHandler
{
    MCAssert(NO);
}

- (void)registerUser
{
    MCLog(@"registerUser");
    User *user = [self.objectModel currentUser];
    MCAssert(user.personalProfile || (user.personalProfile && user.businessProfile));
    MCAssert(user.email);

    NSString *email = user.email;
	NSString *password = user.password;

    RegisterOperation *operation = [RegisterOperation operationWithEmail:email
																password:password];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setCompletionHandler:^(NSError *error) {
        MCLog(@"Register result:%@", error);
        if (error)
		{
            weakSelf.paymentErrorHandler(error);
            return;
        }
		
		[weakSelf updateSenderProfile:^{
			[weakSelf handleNextStepOfPendingPaymentCommit];
		}];
	}];

    [operation execute];
}

- (void)updateSenderProfile:(TRWActionBlock)completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"updateSenderProfile");
        if ([self.objectModel.currentUser.businessProfile isFilled])
		{
            [self updateBusinessProfile:completion];
        }
		else
		{
            [self updatePersonalProfile:completion];
        }
    });
}

- (void)updateBusinessProfile:(TRWActionBlock)completion
{
    MCLog(@"updateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:self.objectModel.currentUser.businessProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setSaveResultHandler:^(NSError *error)
	{
        if (error)
		{
            weakSelf.paymentErrorHandler(error);
            return;
        }

        [weakSelf updatePersonalProfile:completion];
    }];

    [operation execute];
}

- (void)updatePersonalProfile:(TRWActionBlock)completion
{
    MCLog(@"updatePersonalProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:self.objectModel.currentUser.personalProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setSaveResultHandler:^(NSError *error) {
        if (error)
		{
            weakSelf.paymentErrorHandler(error);
            return;
        }

        completion();
    }];

    [operation execute];
}

- (void)uploadPaymentPurpose
{
    MCLog(@"uploadPaymentPurpose");
    PendingPayment *pendingPayment = [self.objectModel pendingPayment];
    PaymentPurposeOperation *operation = [PaymentPurposeOperation operationWithPurpose:pendingPayment.paymentPurpose forProfile:pendingPayment.profileUsed];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                weakSelf.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadPaymentPurpose done");
            PendingPayment *payment = [weakSelf.objectModel pendingPayment];
            [payment removePaymentPurposeRequiredMarker];
            [weakSelf.objectModel saveContext:^{
                [weakSelf handleNextStepOfPendingPaymentCommit];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadAddressVerification
{
    MCLog(@"uploadAddressVerification");
    NSString *profile = [self.objectModel pendingPayment].profileUsed;
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"address" profile:profile filePath:[PendingPayment addressPhotoPath]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                weakSelf.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadAddressVerification done");
            PendingPayment *payment = [weakSelf.objectModel pendingPayment];
            [payment removeAddressVerificationRequiredMarker];
            [weakSelf.objectModel saveContext:^{
                [weakSelf handleNextStepOfPendingPaymentCommit];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadIdVerification
{
    MCLog(@"uploadIdVerification");
    NSString *profile = [self.objectModel pendingPayment].profileUsed;
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"id" profile:profile filePath:[PendingPayment idPhotoPath]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                weakSelf.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadIdVerification done");
            PendingPayment *payment = [weakSelf.objectModel pendingPayment];
            [payment removeIdVerificationRequiredMarker];
            [weakSelf.objectModel saveContext:^{
                [weakSelf handleNextStepOfPendingPaymentCommit];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadSocialSecurityNumber
{
    MCLog(@"uploadPaymentPurpose");
    PendingPayment *pendingPayment = [self.objectModel pendingPayment];
    __weak typeof(self) weakSelf = self;
    if([pendingPayment.socialSecurityNumber length] == 9)
    {
        SetSSNOperation *operation = [SetSSNOperation operationWithSsn:pendingPayment.socialSecurityNumber resultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
				{
                    weakSelf.paymentErrorHandler(error);
                    return;
                }
                
                MCLog(@"setSSN done");
                PendingPayment *payment = [weakSelf.objectModel pendingPayment];
                [payment removeSsnRequiredMarker];
                [payment removeIdVerificationRequiredMarker];
                [weakSelf.objectModel saveContext:^{
                    [weakSelf handleNextStepOfPendingPaymentCommit];
                }];
            });
            
        }];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        [operation execute];
    }
    else
    {
        if ([PendingPayment isIdVerificationImagePresent])
        {
            [pendingPayment removeSsnRequiredMarker];
            [weakSelf.objectModel saveContext:^{
                [weakSelf handleNextStepOfPendingPaymentCommit];
            }];
        }
        else
        {
            weakSelf.paymentErrorHandler([NSError errorWithDomain:TRWErrorDomain code:0 userInfo:@{@"code":@"SSN"}]);
        }
        
    }
}

- (void)commitPayment
{
    MCLog(@"Commit payment");

    PendingPayment *payment = self.objectModel.pendingPayment;

	NSNumber *transferFee = [payment transferwiseTransferFee];
	NSString *currencyCode = [payment.sourceCurrency code];

    CreatePaymentOperation *operation = [CreatePaymentOperation commitOperationWithPayment:[payment objectID]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
        if (error)
		{
            weakSelf.paymentErrorHandler(error);
            return;
        }

#if USE_FACEBOOK_EVENTS
		MCLog(@"Log FB purchase %@ - %@", transferFee, currencyCode);
		[FBAppEvents logPurchase:[transferFee floatValue] currency:currencyCode];
#endif

        static NSNumberFormatter *__formatter;
        if (!__formatter)
		{
            __formatter = [[NSNumberFormatter alloc] init];
            [__formatter setGeneratesDecimalNumbers:YES];
            [__formatter setLocale:[CalculationResult defaultLocale]];
            [__formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [__formatter setCurrencyDecimalSeparator:@"."];
            [__formatter setCurrencyGroupingSeparator:@""];
        }

#if USE_APPSFLYER_EVENTS
        MCLog(@"Log AppsFlyer purchase %@ - %@", transferFee, currencyCode);
        [[AppsFlyerTracker sharedTracker] setCurrencyCode:currencyCode];
        [AppsFlyerTracker sharedTracker].customerUserID = [weakSelf.objectModel.currentUser pReference];
        [[AppsFlyerTracker sharedTracker] trackEvent:@"purchase" withValue:[__formatter stringFromNumber:transferFee]];
#endif

        [NanTracking trackNanigansEvent:weakSelf.objectModel.currentUser.pReference type:@"purchase" name:@"main" value:[__formatter stringFromNumber:transferFee]];

        [weakSelf.objectModel performBlock:^{
            Payment *createdPayment = (Payment *) [weakSelf.objectModel.managedObjectContext objectWithID:paymentID];
            NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
            details[@"SourceCurrency"] = createdPayment.sourceCurrency.code;
            details[@"SourceAmount"] = createdPayment.payIn;
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:MPPaymentCreated properties:details];
            
#if !TARGET_IPHONE_SIMULATOR
            if ([weakSelf.objectModel hasNoOrOnlyCancelledPaymentsExeptThis:paymentID])
            {
                Event* event = [[EventTracker sharedManager] newEvent:@"InappConversion"];
                [event setOrderId:[NSString stringWithFormat:@"%@",createdPayment.remoteId]];
                [event setCustomerId:[[weakSelf.objectModel currentUser] pReference]];
                [[EventTracker sharedManager] submit:event];
            }
#endif
            
        }];

        [weakSelf presentUploadMoneyController:paymentID];
        if(weakSelf.verificationSuccessBlock)
        {
            weakSelf.verificationSuccessBlock();
            weakSelf.verificationSuccessBlock = nil;
        }
    }];

    [operation execute];
}

- (void)presentRefundAccountViewController
{
    PendingPayment *payment = self.objectModel.pendingPayment;
	
    __weak typeof(self) weakSelf = self;
	TRWActionBlock nextBlock = ^{
		[weakSelf presentNextPaymentScreen];
	};
	
    [self.navigationController pushViewController:[self.controllerFactory getViewControllerWithType:RefundDetailsController
																							 params:@{kPendingPayment: [NSObject getObjectOrNsNull:payment],
																									  kNextActionBlock: [nextBlock copy]}]
										 animated:YES];
	
}

- (void)handleNextStepOfPendingPaymentCommit
{
    MCLog(@"handleNextStepOfPendingPaymentCommit");
    [self.objectModel performBlock:^{
        PendingPayment *payment = self.objectModel.pendingPayment;
        if ([payment needsToCommitRecipientData])
		{
            MCLog(@"commit recipient");
            [[GoogleAnalytics sharedInstance] sendNewRecipentEventWithLabel:GADuringpayment];
            [self commitRecipient:payment.recipient];
        }
		else if ([payment needsToCommitRefundRecipientData])
		{
            MCLog(@"commit refund");
            [self commitRecipient:payment.refundRecipient];
        }
//      SSN verification in app is disabled for now
//		else if (!payment.sendVerificationLaterValue &&[payment ssnVerificationRequired])
//		{
//            MCLog(@"Upload SSN");
//            [self uploadSocialSecurityNumber];
//        }
		else if (!payment.sendVerificationLaterValue && [payment idVerificationRequired])
		{
            MCLog(@"Upload id");
            [self uploadIdVerification];
        }
		else if (!payment.sendVerificationLaterValue && [payment addressVerificationRequired])
		{
            MCLog(@"Upload address");
            [self uploadAddressVerification];
        }
		else if (!payment.sendVerificationLaterValue &&[payment paymentPurposeRequired])
		{
            MCLog(@"Upload payment purpose");
            [self uploadPaymentPurpose];
        }
        else
		{
            [self commitPayment];
        }
    }];
}

- (void)commitRecipient:(Recipient *)recipient
{
    MCLog(@"commitRecipientData");
    RecipientOperation *operation = [RecipientOperation createOperationWithRecipient:recipient.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;

    [operation setResponseHandler:^(NSError *error) {
        [weakSelf setExecutedOperation:nil];

        if (error)
		{
            weakSelf.paymentErrorHandler(error);
            return;
        }

        [weakSelf handleNextStepOfPendingPaymentCommit];
    }];

    [operation execute];
}

- (void)presentNextPaymentScreen
{
    MCLog(@"presentNextPaymentScreen");
    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel pendingPayment];
        if (!payment.recipient)
		{
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressRecipient;
            [self presentRecipientDetails:[payment.user personalProfileFilled]];
        }
        else if ([payment.allowedRecipientTypes indexOfObject:payment.recipient.type] == NSNotFound)
        {
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressRecipient;
            Recipient *template = payment.recipient;
            payment.recipient = nil;
            [self presentRecipientDetails:[payment.user personalProfileFilled] templateRecipient:template];
        }
        else if ([payment.recipient.type recipientAddressRequiredValue] && ! [payment.recipient hasAddress])
        {
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressRecipient;
            Recipient *updateRecipient = payment.recipient;
            payment.recipient = nil;
            [self presentRecipientDetails:[payment.user personalProfileFilled] updateRecipient:updateRecipient];
        }
        else if ([payment.targetCurrency isBicRequiredForType:payment.recipient.type] && ! [[payment.recipient valueForFieldNamed:@"BIC"] length] > 0)
        {
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressRecipient;
            Recipient *updateRecipient = payment.recipient;
            payment.recipient = nil;
            [self presentRecipientDetails:[payment.user personalProfileFilled] updateRecipient:updateRecipient];
        }
		else if (!payment.user.personalProfileFilled)
		{
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressPersonalProfile;
            [self presentPersonalProfileEntry:YES
								   isExisting:[Credentials userLoggedIn]];
        }
		else if (payment.user.personalProfile.sendAsBusinessValue
				 || ([payment.profileUsed isEqualToString:BUSINESS_PROFILE] && !payment.user.businessProfileFilled))
		{
			//reset flag so we won't be coming back here again
			payment.user.personalProfile.sendAsBusinessValue = NO;
            
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressBusinessProfile;
            
			[self presentBusinessProfileScreen];
		}
		else if (payment.isFixedAmountValue && !payment.refundRecipient)
		{
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressRefundRecipient;
            [self presentRefundAccountViewController];
        }
        else if([self isAZOrOK])
        {
            return;
        }
		else
		{
            payment.paymentFlowProgressPreviousValue = payment.paymentFlowProgressValue;
            payment.paymentFlowProgressValue = kProgressConfirm;
            [self presentPaymentConfirmation];
        }
    }];
}

-(BOOL)isAZOrOK
{
    //AZ and OK states in the US currently have no active pay in methods!
    //Prevent payments from being created.
    
    PendingPayment *payment = [self.objectModel pendingPayment];
    BOOL stateIsAZorOK = NO;
    if(payment.sourceCurrency.code && [@"usd" caseInsensitiveCompare:payment.sourceCurrency.code] == NSOrderedSame)
    {
        if(payment.user.personalProfile.sendAsBusinessValue
           || [payment.profileUsed isEqualToString:BUSINESS_PROFILE])
        {
            if([payment.user businessProfileFilled])
            {
                stateIsAZorOK = payment.user.businessProfile.state && ([@"AZ" caseInsensitiveCompare:payment.user.businessProfile.state] == NSOrderedSame || [@"OK" caseInsensitiveCompare:payment.user.businessProfile.state] == NSOrderedSame);
            }
        }
        else if ([payment.user personalProfileFilled])
        {
            stateIsAZorOK = payment.user.personalProfile.state && ([@"AZ" caseInsensitiveCompare:payment.user.personalProfile.state] == NSOrderedSame || [@"OK" caseInsensitiveCompare:payment.user.personalProfile.state] == NSOrderedSame );
            
        }
        
        if(stateIsAZorOK)
        {
            TransparentModalViewController* failModal = [self.controllerFactory getCustomModalWithType:NoPayInMethodsFailModal params:@{kPayment: [NSObject getObjectOrNsNull:payment]}];
            [failModal presentOnViewController:self.navigationController.parentViewController];
        }
    }
    
    return stateIsAZorOK;
}

@end
