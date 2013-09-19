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

@class PaymentFlow;
@class ObjectModel;

@interface IdentificationViewController : DataEntryViewController

@property (nonatomic, weak) PaymentFlow *paymentFlow;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL hideSkipOption;
@property (nonatomic, assign) IdentificationRequired identificationRequired;
@property (nonatomic, copy) NSString *proposedFooterButtonTitle;

@end
