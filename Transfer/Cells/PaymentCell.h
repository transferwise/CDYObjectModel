//
//  PaymentCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@class Payment;

@interface PaymentCell : UITableViewCell

- (void)configureWithPayment:(Payment *)payment;
- (void)showCancelButton:(BOOL)animated action:(TRWActionBlock)action;
- (void)hideCancelButton:(BOOL)animated;

@end
