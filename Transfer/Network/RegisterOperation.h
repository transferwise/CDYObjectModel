//
//  RegisterOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^RegisterResponseBlock)(NSError *error);

@interface RegisterOperation : TransferwiseOperation

@property (nonatomic, copy) RegisterResponseBlock completionHandler;

+ (RegisterOperation *)operationWithEmail:(NSString *)email password:(NSString *)password;

@end
