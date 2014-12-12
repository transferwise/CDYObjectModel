//
//  LoggedInPaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "LoggedInPaymentFlow.h"

@implementation LoggedInPaymentFlow

- (void)commitPaymentWithSuccessBlock:(TRWActionBlock)successBlock
						 errorHandler:(TRWErrorBlock)errorHandler{
    MCLog(@"Commit payment");
    [self setPaymentErrorHandler:errorHandler];
    [self setVerificationSuccessBlock:successBlock];

    [self handleNextStepOfPendingPaymentCommit];
}

@end
