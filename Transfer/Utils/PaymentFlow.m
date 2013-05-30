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
    PersonalProfileViewController *controller = [[PersonalProfileViewController alloc] init];
    __block __weak  PersonalProfileViewController *weakController = controller;
    if (self.recipient) {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)];
    } else {
        [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
    }
    [controller setAfterSaveAction:^{
        [self setUserDetails:weakController.userDetails];
        if (self.recipient) {
            [self presentPaymentConfirmation];
        } else {
            [self presentRecipientDetails];
        }
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentRecipientDetails {
    RecipientViewController *controller = [[RecipientViewController alloc] init];
    __block __weak  RecipientViewController *weakController = controller;
    [controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.confirm.payment.button.title", nil)];
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
    [controller setSenderDetails:self.userDetails];
    [controller setRecipient:self.recipient];
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
            [self commitPaymentWithErrorHandler:self.paymentErrorHandler];
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
        MCLog(@"Handle user creation");
    }
}

- (void)uploadVerificationData {
    MCLog(@"Upload verification data:%d", self.verificationRequired.isAnyVerificationRequired);
    if ([NSNumber numberWithBool:self.verificationRequired.sendLater]) {
        [self.paymentInput setVerificationProvideLater:@"true"];
    } else {
        [self.paymentInput setVerificationProvideLater:@"false"];
    }

    if (self.verificationRequired.isAnyVerificationRequired && !self.verificationRequired.sendLater) {

    } else {
        [self commitPayment];
    }
}

- (void)commitPayment {
    MCLog(@"Commit payment");
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

@end
