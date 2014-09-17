//
//  BankTransferViewController.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class ObjectModel;
@class Payment;
@class PayInMethod;

@interface BankTransferViewController : DataEntryViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) PayInMethod *method;


@end
