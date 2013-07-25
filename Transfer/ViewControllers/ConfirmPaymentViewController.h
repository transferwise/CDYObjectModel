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

@class PaymentFlow;
@class ObjectModel;

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, assign) PaymentFlow *paymentFlow;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
