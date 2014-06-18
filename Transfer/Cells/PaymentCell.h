//
//  PaymentCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;

@interface PaymentCell : UITableViewCell

- (void)configureWithPayment:(Payment *)payment;
- (void)showCancelButton:(BOOL)animated;
- (void)hideCancelButton:(BOOL)animated;

@end
