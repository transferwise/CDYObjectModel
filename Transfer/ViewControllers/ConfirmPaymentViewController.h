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
@class Payment;
@class OHAttributedLabel;
@class ConfirmPaymentCell;

typedef NS_ENUM(short, ConfirmPaymentReportingType) {
    ConfirmPaymentReportingNone = 0,
    ConfirmPaymentReportingLoggedIn,
    ConfirmPaymentReportingNotLoggedIn
};

@interface ConfirmPaymentViewController : DataEntryViewController

@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, assign) PaymentFlow *paymentFlow;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, assign) BOOL showContactSupportCell;
@property (nonatomic, assign) ConfirmPaymentReportingType reportingType;

- (void)fillDeliveryDetails:(OHAttributedLabel *)label;
- (NSAttributedString *)attributedStringWithBase:(NSString *)baseString markedString:(NSString *)marked;
- (IBAction)contactSupportPressed;

@end
