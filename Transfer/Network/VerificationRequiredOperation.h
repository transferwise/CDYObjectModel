//
//  VerificationRequiredOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"

@class PaymentVerificationRequired;

typedef void (^VerificationRequiredBlock)(PaymentVerificationRequired *verificationRequired, NSError *error);

@interface VerificationRequiredOperation : TransferwiseOperation

@property (nonatomic, copy) VerificationRequiredBlock completionHandler;

@end
