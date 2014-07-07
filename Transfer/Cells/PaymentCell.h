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

@interface PaymentCell : UITableViewCell<UIGestureRecognizerDelegate>

- (void)configureWithPayment:(Payment *)payment
			cancelShownBlock:(TRWActionBlock)cancelShownBlock
		   cancelHiddenBlock:(TRWActionBlock)cancelHiddenBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock;

- (void)hideCancelButton:(BOOL)animated;

@end
