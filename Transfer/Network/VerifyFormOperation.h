//
//  VerifyFormOperation.h
//  Transfer
//
//  Created by Juhan Hion on 27.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^VerifyFormBlock)(NSError *error, BOOL success);

@interface VerifyFormOperation : TransferwiseOperation

@property (nonatomic, copy) VerifyFormBlock resultHandler;

- (id)init __attribute__((unavailable("init unavailable, use verifyFormOperationWithData:")));
+ (VerifyFormOperation *)verifyFormOperationWithData:(NSDictionary *)data;

@end
