//
//  NoUserPaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NoUserPaymentFlow.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"

@implementation NoUserPaymentFlow

- (void)presentSenderDetails {
    [self presentPersonalProfileEntry:YES];
}

-(void)commitPaymentWithSuccessBlock:(VerificationStepSuccessBlock)successBlock ErrorHandler:(PaymentErrorBlock)errorHandler{
    MCLog(@"Commit payment");
    [self setPaymentErrorHandler:errorHandler];
    [self setVerificationSuccessBlock:successBlock];

    [self registerUser];
}

- (void)presentFirstPaymentScreen {
    PendingPayment *payment = [self.objectModel pendingPayment];
    if (payment.isFixedAmountValue) {
        [self presentRefundAccountViewController:^{
            [self presentRecipientDetails:NO];
        }];
    } else {
        [self presentRecipientDetails:NO];
    }
}

@end
