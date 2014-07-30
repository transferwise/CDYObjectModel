//
//  RefundDetailsViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 08/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryMultiColumnViewController.h"
#import "RecipientViewController.h"

@class ObjectModel;
@class Currency;
@class RecipientType;
@class CurrenciesOperation;
@class PendingPayment;

@interface RefundDetailsViewController : DataEntryMultiColumnViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Currency *currency;
@property (nonatomic, strong) PendingPayment *payment;
@property (nonatomic, copy) TRWActionBlock afterValidationBlock;

@end
