//
//  TransferPayIPadViewController.h
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferDetailsViewController.h"
#import "ObjectModel.h"

@protocol TransferPayIpadViewControllerDelegate <NSObject>

- (void)cancelPaymentWithConfirmation:(Payment *)payment;

@end

@interface TransferPayIPadViewController : TransferDetailsViewController


@property (nonatomic, strong) ObjectModel *objectModel;
@property (weak, nonatomic) id<TransferPayIpadViewControllerDelegate> delegate;


@end
