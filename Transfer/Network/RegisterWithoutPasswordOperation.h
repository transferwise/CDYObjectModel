//
//  RegisterWithoutPasswordOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "LoginOperation.h"

@interface RegisterWithoutPasswordOperation : TransferwiseOperation

@property (nonatomic, strong) LoginResponseBlock completionHandler;

+ (RegisterWithoutPasswordOperation *)operationWithEmail:(NSString *)email;

@end
