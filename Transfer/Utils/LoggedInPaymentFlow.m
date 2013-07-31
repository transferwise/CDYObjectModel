//
//  LoggedInPaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "LoggedInPaymentFlow.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "Constants.h"

@implementation LoggedInPaymentFlow

- (void)presentSenderDetails {
    User *user = [self.objectModel currentUser];
    if (![user personalProfileFilled]) {
        [self presentPersonalProfileEntry:YES];
    } else if (self.objectModel.pendingPayment.recipient) {
        [self presentPaymentConfirmation];
    } else {
        [self presentRecipientDetails:YES];
    }
}

- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Commit payment");
    [self setPaymentErrorHandler:errorHandler];

    [self uploadVerificationData];
}

@end
