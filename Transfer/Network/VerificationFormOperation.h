//
//  VerificationFormOperation.h
//  Transfer
//
//  Created by Juhan Hion on 19.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^VerificationFormBlock)(NSError *error, NSDictionary *form);

@interface VerificationFormOperation : TransferwiseOperation

@property (nonatomic, readonly) VerificationFormBlock resultHandler;

- (id)init __attribute__((unavailable("init unavailable, use initWithAccount:routingNumber:paymentId")));
+ (VerificationFormOperation *)verificationFormOperationWithAccount:(NSString *)accountNumber
													  routingNumber:(NSString *)routingNumber
														  paymentId:(NSNumber *)paymentId;

@end
