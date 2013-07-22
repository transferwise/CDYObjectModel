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
#import "PlainProfileDetails.h"
#import "ConfirmPaymentViewController.h"
#import "PlainRecipientType.h"
#import "IdentificationViewController.h"
#import "UploadMoneyViewController.h"
#import "PlainPaymentInput.h"
#import "CreatePaymentOperation.h"
#import "VerificationRequiredOperation.h"
#import "PlainPaymentVerificationRequired.h"
#import "Credentials.h"
#import "CalculationResult.h"
#import "UploadVerificationFileOperation.h"
#import "PlainPersonalProfileInput.h"
#import "PersonalProfileOperation.h"
#import "EmailCheckOperation.h"
#import "PlainRecipientProfileInput.h"
#import "RecipientOperation.h"
#import "PlainRecipient.h"
#import "RegisterWithoutPasswordOperation.h"
#import "PlainBusinessProfileInput.h"
#import "BusinessProfileOperation.h"
#import "PaymentProfileViewController.h"
#import "PlainBusinessProfile.h"
#import "TRWAlertView.h"
#import "ObjectModel.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+Currencies.h"
#import "PlainCurrency.h"

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) PlainProfileDetails *businessDetails;
@property (nonatomic, strong) PlainRecipientType *recipientType;
@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, copy) PaymentErrorBlock paymentErrorHandler;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) PlainPaymentVerificationRequired *verificationRequired;
@property (nonatomic, strong) PlainPaymentInput *paymentInput;
@property (nonatomic, strong) PlainPersonalProfileInput *personalProfile;
@property (nonatomic, strong) PlainRecipientProfileInput *recipientProfile;
@property (nonatomic, strong) PlainBusinessProfileInput *businessProfile;

@end

@implementation PaymentFlow

- (id)initWithPresentingController:(UINavigationController *)controller {
    self = [super init];

    if (self) {
        _navigationController = controller;
    }

    return self;
}

- (void)setRecipient:(PlainRecipient *)recipient {
    _recipient = recipient;
    if (_recipient) {
        [self setRecipientProfile:[recipient profileInput]];
    }
}

- (void)setUserDetails:(PlainProfileDetails *)userDetails {
    _userDetails = userDetails;

    if (userDetails.personalProfile) {
        [self setPersonalProfile:[userDetails profileInput]];
    }
}

- (void)setBusinessDetails:(PlainProfileDetails *)businessDetails {
    _businessDetails = businessDetails;

    if (businessDetails.businessProfile) {
        [self setBusinessProfile:[businessDetails.businessProfile input]];
    }
}

- (void)presentSenderDetails {
    [self presentSenderDetails:YES];
}

- (void)presentSenderDetails:(BOOL)allowProfileSwitch {
    PaymentProfileViewController *controller = [[PaymentProfileViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setAllowProfileSwitch:allowProfileSwitch];
    if (self.recipient) {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
    } else {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
    }
    [controller setProfileValidation:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)validateBusinessProfile:(PlainBusinessProfileInput *)profile withHandler:(BusinessProfileValidationBlock)handler {
    MCLog(@"validateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation validateWithData:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    
    [operation setSaveResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                handler(nil, error);
                return;
            }

            [self setBusinessProfile:profile];

            handler(nil, nil);

            if ([self personalProfileFilled]) {
                [self pushNextScreenAfterPersonalProfile];
            } else {
                //TODO jaanus: this class should not show anything on screen
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.needed.popup.title", nil) message:NSLocalizedString(@"personal.profile.needed.popup.message", nil)];
                [alertView setLeftButtonTitle:NSLocalizedString(@"button.title.fill", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];

                [alertView setLeftButtonAction:^{
                    [self presentSenderDetails:NO];
                }];

                [alertView show];
            }
        });
    }];
    
    [operation execute];
}

- (BOOL)personalProfileFilled {
    return [self.objectModel.currentUser personalProfile] != nil;
}

- (void)validatePersonalProfile:(PlainPersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"validateProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation validateOperationWithProfile:profile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                handler(nil, error);
                return;
            }

            [self setPersonalProfile:profile];

            if ([Credentials userLoggedIn]) {
                handler(nil, nil);
                [self pushNextScreenAfterPersonalProfile];
                return;
            }

            [self verifyEmail:profile.email withHandler:handler];
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
            handler(nil, error);
        } else if (!available) {
            NSError *emailError = [[NSError alloc] initWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"personal.profile.email.taken.message", nil)}];
            handler(nil, emailError);
        } else {
            handler(nil, nil);
            [self pushNextScreenAfterPersonalProfile];
        }
    }];

    [operation execute];
}

- (void)pushNextScreenAfterPersonalProfile {
    if (self.recipient) {
        [self presentPaymentConfirmation];
    } else {
        [self presentRecipientDetails];
    }
}

- (void)presentRecipientDetails {
    RecipientViewController *controller = [[RecipientViewController alloc] init];
    __block __weak  RecipientViewController *weakController = controller;
    [controller setObjectModel:self.objectModel];
    [controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.confirm.payment.button.title", nil)];
    [controller setRecipientValidation:self];
    [controller setAfterSaveAction:^{
        [self setRecipient:weakController.selectedRecipient];
        [self setRecipientType:weakController.selectedRecipientType];
        [self setRecipientTypes:weakController.recipientTypes];
        [self presentPaymentConfirmation];
    }];
    [controller setPreLoadRecipientsWithCurrency:[self.objectModel currencyWithCode:self.targetCurrency.code]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentPaymentConfirmation {
    MCLog(@"presentPaymentConfirmation");
    ConfirmPaymentViewController *controller = [[ConfirmPaymentViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    if (self.businessProfile) {
        [controller setSenderIsBusiness:YES];
        [controller setSenderName:self.businessProfile.businessName];
        [controller setSenderEmail:self.userDetails.email];
    } else {
        [controller setSenderName:self.personalProfile.fullName];
        [controller setSenderEmail:self.personalProfile.email];
    }
    [controller setSenderDetails:self.personalProfile];
    [controller setRecipientProfile:self.recipientProfile];
    [controller setRecipientType:self.recipientType];
    [controller setCalculationResult:self.calculationResult];
    [controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
    [controller setPaymentFlow:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentVerificationScreen:(PlainPaymentVerificationRequired *)requiredVerification {
    IdentificationViewController *controller = [[IdentificationViewController alloc] init];
    controller.requiredVerification = requiredVerification;
    controller.paymentFlow = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentUploadMoneyController:(NSManagedObjectID *)paymentID {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"presentUploadMoneyController");
        UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setPayment:(id) [self.objectModel.managedObjectContext objectWithID:paymentID]];
        [self.navigationController pushViewController:controller animated:YES];
    });
}

- (void)validatePayment:(PlainPaymentInput *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Validate payment");
    self.paymentErrorHandler = errorHandler;

    [paymentInput setProfile:self.businessProfile ? @"business" : @"personal"];

    CreatePaymentOperation *operation = [CreatePaymentOperation validateOperationWithInput:paymentInput];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }
        
        [self setPaymentInput:paymentInput];

        MCLog(@"Payment valid");
        [self checkVerificationNeeded];
    }];

    [operation execute];
}

- (void)checkVerificationNeeded {
    MCLog(@"checkVerificationNeeded");
    VerificationRequiredOperation *operation = [VerificationRequiredOperation operationWithData:@{@"payIn" : self.calculationResult.transferwisePayIn, @"sourceCurrency" : self.calculationResult.sourceCurrency}];
    [self setExecutedOperation:operation];

    [operation setCompletionHandler:^(PlainPaymentVerificationRequired *verificationRequired, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self setVerificationRequired:verificationRequired];

        MCLog(@"Any verification required? %d", verificationRequired.isAnyVerificationRequired);
        MCLog(@"Logged in? %d", [Credentials userLoggedIn]);
        if (verificationRequired.isAnyVerificationRequired) {
            MCLog(@"Present verification screen");
            self.paymentErrorHandler(nil);
            [self presentVerificationScreen:verificationRequired];
        } else if ([Credentials userLoggedIn]) {
            MCLog(@"Update sender profile");
            [self updateSenderProfile];
        } else {
            MCLog(@"Register user");
            [self registerUser];
        }
    }];

    [operation execute];
}

- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Commit payment");
    self.paymentErrorHandler = errorHandler;

    if ([Credentials userLoggedIn]) {
        [self uploadVerificationData];
    } else {
       [self registerUser];
    }
}

- (void)registerUser {
    MCLog(@"registerUser");
    MCAssert(self.personalProfile || (self.personalProfile && self.businessProfile));
    MCAssert(self.personalProfile.email);

    NSString *email = self.personalProfile.email;

    RegisterWithoutPasswordOperation *operation = [RegisterWithoutPasswordOperation operationWithEmail:email];
    [self setExecutedOperation:operation];
    [operation setCompletionHandler:^(NSError *error) {
        MCLog(@"Register result:%@", error);
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self updateSenderProfile];
    }];

    [operation execute];
}

- (void)updateSenderProfile {
    MCLog(@"updateSenderProfile");
    if (self.businessProfile) {
        [self updateBusinessProfile];
    } else {
        [self updatePersonalProfile];
    }
}

- (void)updateBusinessProfile {
    MCLog(@"updateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:self.businessProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        User *user = [self.objectModel currentUser];
        [self setBusinessDetails:[user plainUserDetails]];

        [self updatePersonalProfile];
    }];

    [operation execute];
}

- (void)updatePersonalProfile {
    MCLog(@"updatePersonalProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:self.personalProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        User *user = [self.objectModel currentUser];
        [self setUserDetails:[user plainUserDetails]];

        MCLog(@"Recipient created?%d", [self.recipientProfile.id integerValue] != 0);

        if ([self.recipientProfile.id integerValue] == 0) {
            [self commitRecipientData];
        } else {
            [self uploadVerificationData];
        }
    }];

    [operation execute];
}

- (void)commitRecipientData {
    MCLog(@"commitRecipientData");
    RecipientOperation *operation = [RecipientOperation createOperationWithRecipient:self.recipientProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(PlainRecipient *recipient, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        MCLog(@"Recipient:%@", recipient);
        MCLog(@"Recipient id:%@", recipient.id);
        [self setRecipient:recipient];
        [self.paymentInput setRecipientId:recipient.id];
        [self commitPayment];
    }];

    [operation execute];
}

- (void)uploadVerificationData {
    MCLog(@"Upload verification data:%d", self.verificationRequired.isAnyVerificationRequired);
    MCLog(@"Send later:%d", self.verificationRequired.sendLater);
    if (self.verificationRequired.sendLater) {
        [self.paymentInput setVerificationProvideLater:@"true"];
    } else {
        [self.paymentInput setVerificationProvideLater:@"false"];
    }

    if (self.verificationRequired.isAnyVerificationRequired && !self.verificationRequired.sendLater) {
        [self uploadNextVerificationData];
    } else {
        [self commitPayment];
    }
}

- (void)uploadNextVerificationData {
    MCLog(@"uploadNextVerificationData");
    if (self.verificationRequired.idVerificationRequired) {
        [self uploadIdVerification];
    } else if (self.verificationRequired.addressVerificationRequired) {
        [self uploadAddressVerification];
    } else {
        [self commitPayment];
    }
}

- (void)uploadAddressVerification {
    MCLog(@"uploadAddressVerification");
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"address" filePath:self.verificationRequired.addressPhotoPath];
    [self setExecutedOperation:operation];

    [operation setCompletionHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        MCLog(@"uploadAddressVerification done");
        self.verificationRequired.addressVerificationRequired = NO;
        [self uploadNextVerificationData];
    }];

    [operation execute];
}

- (void)uploadIdVerification {
    MCLog(@"uploadIdVerification");
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"id" filePath:self.verificationRequired.idPhotoPath];
    [self setExecutedOperation:operation];

    [operation setCompletionHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        MCLog(@"uploadIdVerification done");
        self.verificationRequired.idVerificationRequired = NO;
        [self uploadNextVerificationData];
    }];

    [operation execute];
}

- (void)commitPayment {
    MCLog(@"Commit payment");
    if (!self.paymentInput.recipientId) {
        [self.paymentInput setRecipientId:self.recipientProfile.id];
    }

    [self.paymentInput setProfile:self.businessProfile ? @"business" : @"personal"];

    MCAssert(self.paymentInput.recipientId);

    CreatePaymentOperation *operation = [CreatePaymentOperation commitOperationWithPayment:self.paymentInput];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self presentUploadMoneyController:paymentID];
    }];

    [operation execute];
}

- (void)validateRecipient:(PlainRecipientProfileInput *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    MCLog(@"Validate recipient");
    RecipientOperation *operation = [RecipientOperation validateOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(PlainRecipient *recipient, NSError *error) {
        [self setRecipientProfile:recipientProfile];

        completion(recipient, error);
    }];

    [operation execute];
}

@end
