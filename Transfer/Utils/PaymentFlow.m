//
//  PaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentFlow.h"
#import "PersonalProfileViewController.h"
#import "RecipientViewController.h"
#import "ConfirmPaymentViewController.h"
#import "PersonalProfileIdentificationViewController.h"
#import "BankTransferViewController.h"
#import "CreatePaymentOperation.h"
#import "VerificationRequiredOperation.h"
#import "Credentials.h"
#import "UploadVerificationFileOperation.h"
#import "PersonalProfileOperation.h"
#import "EmailCheckOperation.h"
#import "RecipientOperation.h"
#import "RegisterWithoutPasswordOperation.h"
#import "BusinessProfileOperation.h"
#import "PaymentProfileViewController.h"
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
#import "BusinessProfileIdentificationViewController.h"
#import "AppsFlyer.h"
#import "CalculationResult.h"
#import "LoggedInPaymentFlow.h"
#import "NanTracking.h"
#import "FBAppEvents.h"
#import "NetworkErrorCodes.h"
#import "AnalyticsCoordinator.h"
#import "_RecipientType.h"
#import "RecipientType.h"
#import "RefundDetailsViewController.h"

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation PaymentFlow

- (id)initWithPresentingController:(UINavigationController *)controller {
    self = [super init];

    if (self) {
        _navigationController = controller;
    }

    return self;
}

- (void)presentSenderDetails {
    MCAssert(NO);
}

- (void)presentPersonalProfileEntry:(BOOL)allowProfileSwitch {
    [[AnalyticsCoordinator sharedInstance] paymentPersonalProfileScreenShown];

    PaymentProfileViewController *controller = [[PaymentProfileViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setAllowProfileSwitch:allowProfileSwitch];
    [controller setAnalyticsReport:YES];
    if (self.objectModel.pendingPayment.recipient) {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
    } else {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
    }
    [controller setProfileValidation:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)validateBusinessProfile:(NSManagedObjectID *)profile withHandler:(BusinessProfileValidationBlock)handler {
    MCLog(@"validateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation validateWithData:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    
    [operation setSaveResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                handler(error);
                return;
            }

            handler(nil);

            PendingPayment *payment = [self.objectModel pendingPayment];
            [payment setProfileUsed:@"business"];
            [self.objectModel saveContext];

            if ([self personalProfileFilled]) {
                [self pushNextScreenAfterPersonalProfile];
            } else {
                //TODO jaanus: this class should not show anything on screen
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.needed.popup.title", nil) message:NSLocalizedString(@"personal.profile.needed.popup.message", nil)];
                [alertView setLeftButtonTitle:NSLocalizedString(@"button.title.fill", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];

                [alertView setLeftButtonAction:^{
                    [self presentPersonalProfileEntry:NO];
                }];

                [alertView show];
            }
        });
    }];
    
    [operation execute];
}

- (BOOL)personalProfileFilled {
    return [self.objectModel.currentUser personalProfileFilled];
}

- (void)validatePersonalProfile:(NSManagedObjectID *)profile withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"validateProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation validateOperationWithProfile:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                handler(error);
                return;
            }

            if ([Credentials userLoggedIn]) {
                handler(nil);
                [self pushNextScreenAfterPersonalProfile];
                return;
            }

            [self verifyEmail:self.objectModel.currentUser.email withHandler:handler];
        });
    }];

    [operation execute];
}

- (void)verifyEmail:(NSString *)email withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"Verify email %@ available", email);
    EmailCheckOperation *operation = [EmailCheckOperation operationWithEmail:email];
    [self setExecutedOperation:operation];

    [operation setResultHandler:^(BOOL available, NSError *error) {
        if (error) {
            handler(error);
        } else if (!available) {
            [[GoogleAnalytics sharedInstance] sendAlertEvent:@"EmailTakenDuringPaymentAlert" withLabel:@""];
            NSError *emailError = [[NSError alloc] initWithDomain:TRWErrorDomain code:ResponseLocalError userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"personal.profile.email.taken.message", nil)}];
            handler(emailError);
        } else {
            handler(nil);
            [self pushNextScreenAfterPersonalProfile];
        }
    }];

    [operation execute];
}

- (void)pushNextScreenAfterPersonalProfile {
    //TODO jaanus: after #106 pending payment should always have recipient, as it's presented before sender details
    if (self.objectModel.pendingPayment.recipient) {
        [self presentPaymentConfirmation];
    } else {
        [self presentRecipientDetails];
    }
}

- (void)presentRecipientDetails {
    [self presentRecipientDetails:YES];
}

- (void)presentRecipientDetails:(BOOL)showMiniProfile {
    [[AnalyticsCoordinator sharedInstance] paymentRecipientProfileScreenShown];

    RecipientViewController *controller = [[RecipientViewController alloc] init];
    if ([Credentials userLoggedIn]) {
        [controller setReportingType:RecipientReportingLoggedIn];
    } else {
        [controller setReportingType:RecipientReportingNotLoggedIn];
    }
    [controller setObjectModel:self.objectModel];
    [controller setShowMiniProfile:showMiniProfile];
    [controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"button.title.continue", nil)];
    [controller setRecipientValidation:self];
    [controller setAfterSaveAction:^{
        [self presentNextScreenAfterRecipientDetails];
    }];
    [controller setPreLoadRecipientsWithCurrency:self.objectModel.pendingPayment.targetCurrency];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentNextScreenAfterRecipientDetails {
    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel pendingPayment];
        if ([payment.user personalProfileFilled]) {
            [self presentPaymentConfirmation];
        } else {
            [self presentPersonalProfileEntry:YES];
        }
    }];
}

- (void)presentPaymentConfirmation {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentPaymentConfirmation");
        ConfirmPaymentViewController *controller = [[ConfirmPaymentViewController alloc] init];
        if ([Credentials userLoggedIn]) {
            [controller setReportingType:ConfirmPaymentReportingLoggedIn];
        } else {
            [controller setReportingType:ConfirmPaymentReportingNotLoggedIn];
        }
        [controller setObjectModel:self.objectModel];
        [controller setPayment:[self.objectModel pendingPayment]];
        [controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
        [controller setPaymentFlow:self];
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)presentVerificationScreen {
	PendingPayment *payment = [self.objectModel pendingPayment];
    [[GoogleAnalytics sharedInstance] sendScreen:@"Personal identification"];

    PersonalProfileIdentificationViewController *controller = [[PersonalProfileIdentificationViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setPaymentFlow:self];
	[controller setIdentificationRequired:(IdentificationRequired) [payment verificiationNeededValue]];
	[controller setProposedPaymentPurpose:[payment proposedPaymentsPurpose]];
    [controller setCompletionMessage:NSLocalizedString(@"identification.creating.payment.message", nil)];
	[controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, PaymentErrorBlock errorBlock) {
        [self.objectModel performBlock:^{
            [payment setSendVerificationLaterValue:skipIdentification];
            [payment setPaymentPurpose:paymentPurpose];

            [self.objectModel saveContext:^{
                [self commitPaymentWithErrorHandler:errorBlock];
            }];
        }];
	}];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentUploadMoneyController:(NSManagedObjectID *)paymentID {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentUploadMoneyController");
        if ([self isKindOfClass:[LoggedInPaymentFlow class]]) {
            [[GoogleAnalytics sharedInstance] sendPaymentEvent:@"PaymentCreated" withLabel:@"logged"];
        } else {
            [[GoogleAnalytics sharedInstance] sendPaymentEvent:@"PaymentCreated" withLabel:@"not logged"];
        }

        UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setPayment:(id) [self.objectModel.managedObjectContext objectWithID:paymentID]];
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)validatePayment:(NSManagedObjectID *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Validate payment");
    self.paymentErrorHandler = errorHandler;

    TRWActionBlock executeValidationBlock = ^{
        CreatePaymentOperation *operation = [CreatePaymentOperation validateOperationWithInput:paymentInput];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];

        [operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
            if (error) {
                self.paymentErrorHandler(error);
                return;
            }

            MCLog(@"Payment valid");
            [self checkVerificationNeeded];
        }];

        [operation execute];
    };

    if ([Credentials userLoggedIn]) {
        [self updateSenderProfile:executeValidationBlock];
    } else {
        executeValidationBlock();
    }
}

- (void)checkVerificationNeeded {
    MCLog(@"checkVerificationNeeded");
    VerificationRequiredOperation *operation = [VerificationRequiredOperation operation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.paymentErrorHandler(error);
                return;
            }

            PendingPayment *pendingPayment = [self.objectModel pendingPayment];
            MCLog(@"Any verification required? %d", pendingPayment.isAnyVerificationRequired);
            MCLog(@"Logged in? %d", [Credentials userLoggedIn]);
            if ([pendingPayment isAnyVerificationRequired] && [[pendingPayment profileUsed] isEqualToString:@"business"]) {
                [self presentBusinessVerificationScreen];
            } else if ([pendingPayment isAnyVerificationRequired]) {
                MCLog(@"Present verification screen");
                self.paymentErrorHandler(nil);
                [self presentVerificationScreen];
            } else if ([Credentials userLoggedIn]) {
                MCLog(@"Update sender profile");
                [self updateSenderProfile:^{
                    //TODO jaanus: copy/paste...
                    Recipient *recipient = self.objectModel.pendingPayment.recipient;

                    MCLog(@"Recipient created?%d", [recipient remoteIdValue] != 0);
                    if ([recipient remoteIdValue] == 0) {
                        [self commitRecipientData];
                    } else {
                        [self uploadVerificationData];
                    }
                }];
            } else {
                MCLog(@"Register user");
                [self registerUser];
            }
        });
    }];

    [operation execute];
}

- (void)presentBusinessVerificationScreen {
    PendingPayment *payment = [self.objectModel pendingPayment];
    [[GoogleAnalytics sharedInstance] sendScreen:@"Business verification"];

    BusinessProfileIdentificationViewController *controller = [[BusinessProfileIdentificationViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, PaymentErrorBlock errorBlock) {
        [self.objectModel performBlock:^{
            [payment setSendVerificationLaterValue:skipIdentification];

            [self.objectModel saveContext:^{
                [self commitPaymentWithErrorHandler:errorBlock];
            }];
        }];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler {
    MCAssert(NO);
}

- (void)registerUser {
    MCLog(@"registerUser");
    User *user = [self.objectModel currentUser];
    MCAssert(user.personalProfile || (user.personalProfile && user.businessProfile));
    MCAssert(user.email);

    NSString *email = user.email;

    RegisterWithoutPasswordOperation *operation = [RegisterWithoutPasswordOperation operationWithEmail:email];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCompletionHandler:^(NSError *error) {
        MCLog(@"Register result:%@", error);
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self updateSenderProfile:^{
            Recipient *recipient = self.objectModel.pendingPayment.recipient;

            MCLog(@"Recipient created?%d", [recipient remoteIdValue] != 0);
            if ([recipient remoteIdValue] == 0) {
                [self commitRecipientData];
            } else {
                [self uploadVerificationData];
            }
        }];
    }];

    [operation execute];
}

- (void)presentFirstPaymentScreen {
    MCAssert(NO);
}


- (void)updateSenderProfile:(TRWActionBlock)completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"updateSenderProfile");
        if ([self.objectModel.currentUser.businessProfile isFilled]) {
            [self updateBusinessProfile:completion];
        } else {
            [self updatePersonalProfile:completion];
        }
    });
}

- (void)updateBusinessProfile:(TRWActionBlock)completion {
    MCLog(@"updateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:self.objectModel.currentUser.businessProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self updatePersonalProfile:completion];
    }];

    [operation execute];
}

- (void)updatePersonalProfile:(TRWActionBlock)completion {
    MCLog(@"updatePersonalProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:self.objectModel.currentUser.personalProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        completion();
    }];

    [operation execute];
}

- (void)commitRecipientData {
    MCLog(@"commitRecipientData");
    [[GoogleAnalytics sharedInstance] sendEvent:@"RecipientAdded" category:@"recipient" label:@"DuringPayment"];
    RecipientOperation *operation = [RecipientOperation createOperationWithRecipient:self.objectModel.pendingPayment.recipient.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self commitPayment];
    }];

    [operation execute];
}

- (void)uploadVerificationData {
    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel pendingPayment];
        if (payment.isAnyVerificationRequired && payment.sendVerificationLaterValue) {
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"skipped"];
        } else if (payment.isAnyVerificationRequired) {
            [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
        }
        if ([payment isAnyVerificationRequired] && !payment.sendVerificationLaterValue) {
            [self uploadNextVerificationData];
        } else {
            [self commitPayment];
        }
    }];
}

- (void)uploadNextVerificationData {
    MCLog(@"uploadNextVerificationData");
    [self.objectModel performBlock:^{
        PendingPayment *payment = [self.objectModel pendingPayment];
        if ([payment idVerificationRequired]) {
            [self uploadIdVerification];
        } else if ([payment addressVerificationRequired]) {
            [self uploadAddressVerification];
        } else if ([payment paymentPurposeRequired]) {
            [self uploadPaymentPurpose];
        } else {
            [self commitPayment];
        }
    }];
}

- (void)uploadPaymentPurpose {
    MCLog(@"uploadPaymentPurpose");
    PendingPayment *pendingPayment = [self.objectModel pendingPayment];
    PaymentPurposeOperation *operation = [PaymentPurposeOperation operationWithPurpose:pendingPayment.paymentPurpose forProfile:pendingPayment.profileUsed];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadPaymentPurpose done");
            PendingPayment *payment = [self.objectModel pendingPayment];
            [payment removePaymentPurposeRequiredMarker];
            [self.objectModel saveContext:^{
                [self uploadNextVerificationData];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadAddressVerification {
    MCLog(@"uploadAddressVerification");
    NSString *profile = [self.objectModel pendingPayment].profileUsed;
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"address" profile:profile filePath:[PendingPayment addressPhotoPath]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadAddressVerification done");
            PendingPayment *payment = [self.objectModel pendingPayment];
            [payment removerAddressVerificationRequiredMarker];
            [self.objectModel saveContext:^{
                [self uploadNextVerificationData];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadIdVerification {
    MCLog(@"uploadIdVerification");
    NSString *profile = [self.objectModel pendingPayment].profileUsed;
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"id" profile:profile filePath:[PendingPayment idPhotoPath]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.paymentErrorHandler(error);
                return;
            }

            MCLog(@"uploadIdVerification done");
            PendingPayment *payment = [self.objectModel pendingPayment];
            [payment removeIdVerificationRequiredMarker];
            [self.objectModel saveContext:^{
                [self uploadNextVerificationData];
            }];
        });
    }];

    [operation execute];
}

- (void)commitPayment {
    MCLog(@"Commit payment");

    PendingPayment *payment = self.objectModel.pendingPayment;

	NSNumber *transferFee = [payment transferwiseTransferFee];
	NSString *currencyCode = [payment.sourceCurrency code];

    if ([payment.recipient remoteIdValue] == 0) {
        [self commitRecipientData];
        return;
    }

    CreatePaymentOperation *operation = [CreatePaymentOperation commitOperationWithPayment:[payment objectID]];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

#if USE_FACEBOOK_EVENTS
		MCLog(@"Log FB purchase %@ - %@", transferFee, currencyCode);
		[FBAppEvents logPurchase:[transferFee floatValue] currency:currencyCode];
#endif

        static NSNumberFormatter *__formatter;
        if (!__formatter) {
            __formatter = [[NSNumberFormatter alloc] init];
            [__formatter setGeneratesDecimalNumbers:YES];
            [__formatter setLocale:[CalculationResult defaultLocale]];
            [__formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [__formatter setCurrencyDecimalSeparator:@"."];
            [__formatter setCurrencyGroupingSeparator:@""];
        }

#if USE_APPSFLYER_EVENTS
        MCLog(@"Log AppsFlyer purchase %@ - %@", transferFee, currencyCode);
        [AppsFlyer setCurrencyCode:currencyCode];
        [AppsFlyer setAppUID:[self.objectModel.currentUser pReference]];
        [AppsFlyer notifyAppID:AppsFlyerIdentifier event:@"purchase" eventValue:[__formatter stringFromNumber:transferFee]];
#endif

        [NanTracking trackNanigansEvent:self.objectModel.currentUser.pReference type:@"purchase" name:@"main" value:[__formatter stringFromNumber:transferFee]];

        [self.objectModel performBlock:^{
            Payment *createdPayment = (Payment *) [self.objectModel.managedObjectContext objectWithID:paymentID];
            NSMutableDictionary *details = [NSMutableDictionary dictionary];
            details[@"recipientType"] = createdPayment.recipient.type.type;
            details[@"sourceCurrency"] = createdPayment.sourceCurrency.code;
            details[@"sourceValue"] = createdPayment.payIn;
            details[@"targetCurrency"] = createdPayment.targetCurrency.code;
            details[@"targetValue"] = createdPayment.payOut;
            details[@"userType"] = createdPayment.profileUsed;

            [[AnalyticsCoordinator sharedInstance] didCreatePayment:details];
        }];

        [self presentUploadMoneyController:paymentID];
    }];

    [operation execute];
}

- (void)validateRecipient:(NSManagedObjectID *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    MCLog(@"Validate recipient");
    RecipientOperation *operation = [RecipientOperation validateOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:completion];

    [operation execute];
}

- (void)presentRefundAccountViewController:(TRWActionBlock)completion {
    PendingPayment *payment = self.objectModel.pendingPayment;
    RefundDetailsViewController *controller = [[RefundDetailsViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setCurrency:payment.sourceCurrency];
    [controller setPayment:payment];
    [controller setAfterValidationBlock:completion];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
