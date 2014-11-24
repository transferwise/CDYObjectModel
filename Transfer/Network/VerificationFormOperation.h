//
//  VerificationFormOperation.h
//  Transfer
//
//  Created by Juhan Hion on 19.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^VerificationFormBlock)(NSError *error, NSDictionary* form);

@interface VerificationFormOperation : TransferwiseOperation

@property (nonatomic, copy) VerificationFormBlock resultHandler;

- (id)init __attribute__((unavailable("init unavailable, use verificationFormOperationWithAccount:routingNumber:paymentId")));
+ (VerificationFormOperation *)verificationFormOperationWithAccount:(NSString *)accountNumber
													  routingNumber:(NSString *)routingNumber
														  paymentId:(NSNumber *)paymentId;

@end
