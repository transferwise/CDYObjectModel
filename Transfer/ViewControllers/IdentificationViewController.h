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
#import "PaymentFlow.h"

@class PaymentFlow;
@class ObjectModel;

typedef void (^IdentificationCompleteBlock)(BOOL skipIdentification, NSString *paymentPurpose, PaymentErrorBlock errorBlock);

@interface IdentificationViewController : DataEntryViewController

@property (nonatomic, copy) IdentificationCompleteBlock completionHandler;
@property (nonatomic, weak) PaymentFlow *paymentFlow;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL hideSkipOption;
@property (nonatomic, assign) IdentificationRequired identificationRequired;
@property (nonatomic, copy) NSString *proposedFooterButtonTitle;
@property (nonatomic, copy) NSString *proposedPaymentPurpose;
@property (nonatomic, copy) NSString *completionMessage;

@end
