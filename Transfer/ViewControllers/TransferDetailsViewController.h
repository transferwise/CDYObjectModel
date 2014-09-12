//
//  TransferDetailsViewController.h
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Payment.h"

@class Payment;
@class Recipient;

@interface TransferDetailsViewController : UIViewController

@property (nonatomic) BOOL showClose;
@property (weak, nonatomic) Payment *payment;

- (void)setUpHeader;
- (void)setUpAmounts;
- (void)setUpAccounts;

- (NSString*)getStatusBasedLocalization:(NSString *)localizationKey status:(NSString*)status;
- (void)setBackOrCloseButton;

@end
