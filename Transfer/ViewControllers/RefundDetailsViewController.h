//
//  RefundDetailsViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 08/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RecipientViewController.h"

@class ObjectModel;
@class Currency;
@class RecipientType;
@class CurrenciesOperation;

@interface RefundDetailsViewController : DataEntryViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Currency *currency;

@end
