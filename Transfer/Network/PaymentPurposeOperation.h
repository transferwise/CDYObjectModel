//
//  PaymentPurposeOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 9/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^PaypentPurposePostHandler)(NSError *error);

@interface PaymentPurposeOperation : TransferwiseOperation

@property (nonatomic, copy) PaypentPurposePostHandler resultHandler;

+ (PaymentPurposeOperation *)operationWithPurpose:(NSString *)paymentPurpose forProfile:(NSString *)profile;

@end
