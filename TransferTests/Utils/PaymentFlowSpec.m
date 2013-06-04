//
//  PaymentFlowSpec.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Kiwi.h"
#import "PaymentFlow.h"

SPEC_BEGIN(PaymentFlowSpeck)

    describe(@"Payment flow", ^{

        __block PaymentFlow *paymentFlow;
        __block UINavigationController *presentedOnController;

        beforeEach(^{
            presentedOnController = [UINavigationController mock];
            paymentFlow = [[PaymentFlow alloc] initWithPresentingController:presentedOnController];
        });


    });

SPEC_END