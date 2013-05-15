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
#import "Recipient.h"
#import "RecipientType.h"
#import "IdentificationViewController.h"
#import "UploadMoneyViewController.h"
#import "Payment.h"

@interface PaymentFlow ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, strong) Payment *createdPayment;
@property (nonatomic, strong) NSArray *recipientTypes;

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
    [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.continue.to.recipient.button.title", nil)];
    [controller setAfterSaveAction:^{
        [self setUserDetails:weakController.userDetails];
        [self presentRecipientDetails];
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
    __block __weak ConfirmPaymentViewController *weakController = controller;
    [controller setSenderDetails:self.userDetails];
    [controller setRecipient:self.recipient];
    [controller setRecipientType:self.recipientType];
    [controller setCalculationResult:self.calculationResult];
    [controller setFooterButtonTitle:NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
    [controller setAfterSaveAction:^{
        [self setCreatedPayment:weakController.createdPayment];
        [self presentVerificationScreen];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentVerificationScreen {
    IdentificationViewController *controller = [[IdentificationViewController alloc] init];
    [controller setAfterSaveBlock:^{
        [self presentUploadMoneyController];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)presentUploadMoneyController {
    UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
    [controller setUserDetails:self.userDetails];
    [controller setPayment:self.createdPayment];
    [controller setRecipientTypes:self.recipientTypes];
    [self.navigationController pushViewController:controller animated:YES];
}

@end