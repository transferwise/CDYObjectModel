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

@class PlainProfileDetails;
@class PlainRecipient;
@class PlainRecipientType;
@class CalculationResult;
@class PlainPayment;
@class PaymentFlow;
@class PlainRecipientProfileInput;
@class PlainPersonalProfileInput;
@class ObjectModel;

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, strong) PlainPersonalProfileInput *senderDetails;
@property (nonatomic, strong) PlainRecipientProfileInput *recipientProfile;
@property (nonatomic, strong) PlainRecipientType *recipientType;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, assign) PaymentFlow *paymentFlow;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderEmail;
@property (nonatomic, assign) BOOL senderIsBusiness;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
