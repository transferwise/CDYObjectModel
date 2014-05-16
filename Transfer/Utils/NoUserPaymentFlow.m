//
//  NoUserPaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NoUserPaymentFlow.h"

@implementation NoUserPaymentFlow

- (void)commitPaymentWithErrorHandler:(PaymentErrorBlock)errorHandler {
    MCLog(@"Commit payment");
    [self setPaymentErrorHandler:errorHandler];

    [self registerUser];
}

@end
