//
//  IdentificationViewController.h
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"
#import "Constants.h"

@class PlainPaymentVerificationRequired;
@class PaymentFlow;

@interface IdentificationViewController : DataEntryViewController

@property (nonatomic, strong) PlainPaymentVerificationRequired *requiredVerification;
@property (nonatomic, weak) PaymentFlow *paymentFlow;

@end
