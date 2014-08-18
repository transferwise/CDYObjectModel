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

@class ObjectModel;

typedef void(^CancelPaymentResultBlock)(NSError* error);

@interface CancelHelper : NSObject

+ (void)cancelPayment:(Payment *)payment host:(id)host objectModel:(ObjectModel*)model
		  cancelBlock:(CancelPaymentResultBlock)cancelBlock
	  dontCancelBlock:(TRWActionBlock)dontCancelBlock;

@end
