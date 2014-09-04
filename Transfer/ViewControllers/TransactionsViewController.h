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
#import "CancellableCellViewController.h"

@class ObjectModel;

@interface TransactionsViewController : CancellableCellViewController<TransferPayIpadViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;

- (void)clearData;

@end
