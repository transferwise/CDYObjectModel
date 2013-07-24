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

@class PlainRecipientType;
@class CalculationResult;
@class PaymentFlow;
@class ObjectModel;

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong) CalculationResult *calculationResult;
@property (nonatomic, assign) PaymentFlow *paymentFlow;
@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *senderEmail;
@property (nonatomic, assign) BOOL senderIsBusiness;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
