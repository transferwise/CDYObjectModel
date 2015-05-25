//
//  PendingPayment+ColoredButton.m
//  Transfer
//
//  Created by Mats Trovik on 11/03/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PendingPayment+ColoredButton.h"
#import "ColoredButton.h"

@implementation PendingPayment (ColoredButton)

-(void)addProgressAnimationToButton:(ColoredButton*)button
{
    [button progressPushVCAnimationFrom:MIN(self.paymentFlowProgressPreviousValue,self.paymentFlowProgressValue) to:self.paymentFlowProgressValue];
}

@end
