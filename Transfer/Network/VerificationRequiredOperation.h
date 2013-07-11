//
//  VerificationRequiredOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"

@class PlainPaymentVerificationRequired;

typedef void (^VerificationRequiredBlock)(PlainPaymentVerificationRequired *verificationRequired, NSError *error);

@interface VerificationRequiredOperation : TransferwiseOperation

@property (nonatomic, copy) VerificationRequiredBlock completionHandler;

+ (VerificationRequiredOperation *)operationWithData:(NSDictionary *)data;

@end
