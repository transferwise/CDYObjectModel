//
//  PaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlainRecipient;
@class ObjectModel;
@class CurrencyPairsOperation;

@interface PaymentViewController : UITableViewController

@property (nonatomic, strong) PlainRecipient *recipient;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
