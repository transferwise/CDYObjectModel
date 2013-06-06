//
//  ConfirmPaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 5/8/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"
#import "Constants.h"

@class ProfileDetails;
@class Recipient;
@class RecipientType;
@class CalculationResult;
@class Payment;
@class PaymentFlow;
@class RecipientProfileInput;
@class PersonalProfileInput;

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, strong) PersonalProfileInput *senderDetails;
@property (nonatomic, strong) RecipientProfileInput *recipientProfile;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, assign) PaymentFlow *paymentFlow;

@end
