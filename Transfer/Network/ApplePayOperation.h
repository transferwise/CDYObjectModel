//
//  ApplePayTokenOperation.h
//  Transfer
//
//  Created by Nick Banks on 08/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//


#import "TransferwiseOperation.h"
#import "Constants.h"

typedef void (^ApplePayTokenResponseBlock)(NSError *error, NSDictionary *result);

@interface ApplePayOperation : TransferwiseOperation

@property (nonatomic, copy) ApplePayTokenResponseBlock responseHandler;

// Factory
+ (instancetype) applePayOperationWithPaymentId: (NSString *) paymentId
                                       andToken: (NSString *) token;

@end

