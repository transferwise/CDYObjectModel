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
@class TransactionsViewController;


@interface TransactionsViewController : CancellableCellViewController<TransferPayIpadViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL refreshOnAppear;
@property (nonatomic, strong) NSNumber* deeplinkPaymentID;
@property (nonatomic, assign) BOOL deeplinkDisplayVerification;

- (void)clearData;

@end
