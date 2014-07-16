//
//  TransactionsViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "TransferPayIPadViewController.h"
#import "CancelableCellViewController.h"

@class ObjectModel;

@interface TransactionsViewController : CancelableCellViewController<TransferPayIpadViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
