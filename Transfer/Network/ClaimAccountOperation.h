//
//  ClaimAccountOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 6/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ClaimAccountResult)(NSError *error);

@interface ClaimAccountOperation : TransferwiseOperation

@property (nonatomic, copy) ClaimAccountResult resultHandler;

- (id)initWithPassword:(NSString *)password;

+ (ClaimAccountOperation *)operationWithPassword:(NSString *)password;

@end
