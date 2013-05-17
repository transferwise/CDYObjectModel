//
//  RegisterOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "LoginOperation.h"

@interface RegisterOperation : TransferwiseOperation

@property (nonatomic, copy) LoginResponseBlock completionHandler;

+ (RegisterOperation *)operationWithEmail:(NSString *)email password:(NSString *)password;

@end
