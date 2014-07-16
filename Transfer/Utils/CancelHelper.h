//
//  CancelHelper.h
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Payment.h"
#import "TRWAlertView.h"

@interface CancelHelper : NSObject

+ (void)cancelPayment:(Payment *)payment
		  cancelBlock:(TRWActionBlock)cancelBlock
	  dontCancelBlock:(TRWActionBlock)dontCancelBlock;

@end
