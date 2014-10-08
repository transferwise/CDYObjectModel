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

@protocol HighlightLackOfTransfersDelegate <NSObject>

@required
-(void)setHighlightingForLackOfTransfers:(BOOL)turnedOn fromController:(TransactionsViewController*)controller;

@end


@interface TransactionsViewController : CancellableCellViewController<TransferPayIpadViewControllerDelegate>

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, weak) id<HighlightLackOfTransfersDelegate> lackOfTransfersDelegate;

- (void)clearData;

@end
