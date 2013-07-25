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
#import "IdentificationViewController.h"
#import "UploadMoneyViewController.h"
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

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, copy) PaymentErrorBlock paymentErrorHandler;
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
    [self presentSenderDetails:YES];
}

- (void)presentSenderDetails:(BOOL)allowProfileSwitch {
    PaymentProfileViewController *controller = [[PaymentProfileViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setAllowProfileSwitch:allowProfileSwitch];
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

- (void)validatePersonalProfile:(NSManagedObjectID *)profile withHandler:(PersonalProfileValidationBlock)handler {
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

            if ([Credentials userLoggedIn]) {
                handler(nil, nil);
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
    if (self.objectModel.pendingPayment.recipient) {
        [self presentPaymentConfirmation];
    } else {
        [self presentRecipientDetails];
    }
}

- (void)presentRecipientDetails {
    RecipientViewController *controller = [[RecipientViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setTitle:NSLocalizedString(@"recipient.controller.payment.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.confirm.payment.button.title", nil)];
    [controller setRecipientValidation:self];
    [controller setAfterSaveAction:^{
        [self presentPaymentConfirmation];
    }];
    [controller setPreLoadRecipientsWithCurrency:self.objectModel.pendingPayment.targetCurrency];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentPaymentConfirmation {
    MCLog(@"presentPaymentConfirmation");
    ConfirmPaymentViewController *controller = [[ConfirmPaymentViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
    [controller setPaymentFlow:self];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentVerificationScreen {
    IdentificationViewController *controller = [[IdentificationViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setPaymentFlow:self];
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

- (void)validatePayment:(NSManagedObjectID *)paymentInput errorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Validate payment");
    self.paymentErrorHandler = errorHandler;

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
            if ([pendingPayment isAnyVerificationRequired]) {
                MCLog(@"Present verification screen");
                self.paymentErrorHandler(nil);
                [self presentVerificationScreen];
            } else if ([Credentials userLoggedIn]) {
                MCLog(@"Update sender profile");
                [self updateSenderProfile];
            } else {
                MCLog(@"Register user");
                [self registerUser];
            }
        });
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
    User *user = [self.objectModel currentUser];
    MCAssert(user.personalProfile || (user.personalProfile && user.businessProfile));
    MCAssert(user.email);

    NSString *email = user.email;

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
    [self updateBusinessProfile];
}

- (void)updateBusinessProfile {
    MCLog(@"updateBusinessProfile");
    BusinessProfileOperation *operation = [BusinessProfileOperation commitWithData:self.objectModel.currentUser.businessProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        [self updatePersonalProfile];
    }];

    [operation execute];
}

- (void)updatePersonalProfile {
    MCLog(@"updatePersonalProfile");
    PersonalProfileOperation *operation = [PersonalProfileOperation commitOperationWithProfile:self.objectModel.currentUser.personalProfile.objectID];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setSaveResultHandler:^(NSError *error) {
        if (error) {
            self.paymentErrorHandler(error);
            return;
        }

        Recipient *recipient = self.objectModel.pendingPayment.recipient;

        MCLog(@"Recipient created?%d", [recipient remoteIdValue] != 0);

        if ([recipient remoteIdValue] == 0) {
            [self commitRecipientData];
        } else {
            [self uploadVerificationData];
        }
    }];

    [operation execute];
}

- (void)commitRecipientData {
    MCLog(@"commitRecipientData");
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
        if (payment.idVerificationRequiredValue) {
            [self uploadIdVerification];
        } else if (payment.addressVerificationRequiredValue) {
            [self uploadAddressVerification];
        } else {
            [self commitPayment];
        }
    }];
}

- (void)uploadAddressVerification {
    MCLog(@"uploadAddressVerification");
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"address" filePath:[PendingPayment addressPhotoPath]];
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
            [payment setAddressVerificationRequiredValue:NO];
            [self.objectModel saveContext:^{
                [self uploadNextVerificationData];
            }];
        });
    }];

    [operation execute];
}

- (void)uploadIdVerification {
    MCLog(@"uploadIdVerification");
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:@"id" filePath:[PendingPayment idPhotoPath]];
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
            [payment setIdVerificationRequiredValue:NO];
            [self.objectModel saveContext:^{
                [self uploadNextVerificationData];
            }];
        });
    }];

    [operation execute];
}

- (void)commitPayment {
    MCLog(@"Commit payment");

    MCAssert(self.objectModel.pendingPayment.recipient.remoteIdValue != 0);

    CreatePaymentOperation *operation = [CreatePaymentOperation commitOperationWithPayment:[self.objectModel.pendingPayment objectID]];
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

- (void)validateRecipient:(NSManagedObjectID *)recipientProfile completion:(RecipientProfileValidationBlock)completion {
    MCLog(@"Validate recipient");
    RecipientOperation *operation = [RecipientOperation validateOperationWithRecipient:recipientProfile];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:completion];

    [operation execute];
}

@end
