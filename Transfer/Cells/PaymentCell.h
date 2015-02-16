//
//  PaymentCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SwipeActionCell.h"

@class Payment;

@interface PaymentCell : SwipeActionCell

- (void)configureWithPayment:(Payment *)payment
		 willShowActionButtonBlock:(TRWActionBlock)willShowCancelBlock
		  didShowActionButtonBlock:(TRWActionBlock)didShowCancelBlock
		  didHideActionButtonBlock:(TRWActionBlock)didHideCancelBlock
		   actionTappedBlock:(TRWActionBlock)cancelTappedBlock;

@end
