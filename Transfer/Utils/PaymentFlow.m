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
#import "ProfileDetails.h"
#import "ConfirmPaymentViewController.h"
#import "RecipientType.h"
#import "IdentificationViewController.h"
#import "UploadMoneyViewController.h"
#import "Payment.h"
#import "PaymentInput.h"
#import "CreatePaymentOperation.h"
#import "VerificationRequiredOperation.h"
#import "PaymentVerificationRequired.h"
#import "Credentials.h"
#import "CalculationResult.h"
#import "UploadVerificationFileOperation.h"
#import "PersonalProfileInput.h"
#import "PersonalProfileOperation.h"
#import "EmailCheckOperation.h"
#import "RecipientProfileInput.h"
#import "RecipientOperation.h"
#import "Recipient.h"
#import "RegisterWithoutPasswordOperation.h"

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, strong) Payment *createdPayment;
@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, copy) PaymentErrorBlock paymentErrorHandler;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) PaymentVerificationRequired *verificationRequired;
@property (nonatomic, strong) PaymentInput *paymentInput;
@property (nonatomic, strong) PersonalProfileInput *personalProfile;
@property (nonatomic, strong) RecipientProfileInput *recipientProfile;

@end

@implementation PaymentFlow

- (id)initWithPresentingController:(UINavigationController *)controller {
    self = [super init];

    if (self) {
        _navigationController = controller;
    }

    return self;
}

- (void)setRecipient:(Recipient *)recipient {
    _recipient = recipient;
    if (_recipient) {
        [self setRecipientProfile:[recipient profileInput]];
    }
}

- (void)setUserDetails:(ProfileDetails *)userDetails {
    _userDetails = userDetails;

    if (userDetails) {
        [self setPersonalProfile:[userDetails profileInput]];
    }
}

- (void)presentSenderDetails {
    PersonalProfileViewController *controller = [[PersonalProfileViewController alloc] init];
    if (self.recipient) {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
    } else {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
    }
    [controller setProfileValidation:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)validateProfile:(PersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler {
    MCLog(@"validateProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation validateOperationWithProfile:profile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        if (error) {
            handler(result, error);
            return;
        }

        [self setPersonalProfile:profile];

        if ([Credentials userLoggedIn]) {
            handler(nil, nil);
            [self pushNextScreenAfterPersonalProfile];
            return;
        }

        [self verifyEmail:profile.email withHandler:handler];
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
    [controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.confirm.payment.button.title", nil)];
    [controller setRecipientValidation:self];
    [controller setAfterSaveAction:^{
        [self setRecipient:weakController.selectedRecipient];
        [self setRecipientType:weakController.selectedRecipientType];
        [self setRecipientTypes:weakController.recipientTypes];
        [self presentPaymentConfirmation];
    }];
    [controller setPreloadRecipientsWithCurrency:self.targetCurrency];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentPaymentConfirmation {
    MCLog(@"presentPaymentConfirmation");
    ConfirmPaymentViewController *controller = [[ConfirmPaymentViewController alloc] init];
    [controller setSenderDetails:self.personalProfile];
    [controller setRecipientProfile:self.recipientProfile];
    [controller setRecipientType:self.recipientType];
    [controller setCalculationResult:self.calculationResult];
    [controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
    [controller setPaymentFlow:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentVerificationScreen:(PaymentVerificationRequired *)requiredVerification {
    IdentificationViewController *controller = [[IdentificationViewController alloc] init];
    controller.requiredVerification = requiredVerification;
    controller.paymentFlow = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentUploadMoneyController {
    MCLog(@"presentUploadMoneyController");
    UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
    [controller setUserDetails:self.userDetails];
    [controller setPayment:self.createdPayment];
    [controller setRecipientTypes:self.recipientTypes];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)validatePayment:(PaymentInput *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Validate payment");
    self.paymentErrorHandler = errorHandler;

    CreatePaymentOperation *operation = [CreatePaymentOperation validateOperationWithInput:paymentInput];
    [self setExecutedOperation:operation];

    [operation setResponseHandler:^(Payment *payment, NSError *error) {
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

    [operation setCompletionHandler:^(PaymentVerificationRequired *verificationRequired, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self setVerificationRequired:verificationRequired];

        MCLog(@"Any verification required? %d", verificationRequired.isAnyVerificationRequired);
        if (verificationRequired.isAnyVerificationRequired) {
            self.paymentErrorHandler(nil);
            [self presentVerificationScreen:verificationRequired];
        } else {
            [self updateSenderProfile];
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
    PSPDFAssert(self.personalProfile);
    PSPDFAssert(self.personalProfile.email);

    RegisterWithoutPasswordOperation *operation = [RegisterWithoutPasswordOperation operationWithEmail:self.personalProfile.email];
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
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:self.personalProfile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self setUserDetails:result];

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

    [operation setResponseHandler:^(Recipient *recipient, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

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
    PSPDFAssert(self.paymentInput.recipientId);

    CreatePaymentOperation *operation = [CreatePaymentOperation commitOperationWithPayment:self.paymentInput];
    [self setExecutedOperation:operation];

    [operation setResponseHandler:^(Payment *payment, NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        self.createdPayment = payment;
        [self presentUploadMoneyController];
    }];

    [operation execute];
}

- (void)validateRecipient:(RecipientProfileInput *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    MCLog(@"Validate recipient");
    RecipientOperation *operation = [RecipientOperation validateOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];

    [operation setResponseHandler:^(Recipient *recipient, NSError *error) {
        [self setRecipientProfile:recipientProfile];

        completion(recipient, error);
    }];

    [operation execute];
}

@end
