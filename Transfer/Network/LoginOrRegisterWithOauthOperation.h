//
//  LoginOrRegisterWithOauthOperation.h
//  Transfer
//
//  Created by Juhan Hion on 25.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

@interface LoginOrRegisterWithOauthOperation : TransferwiseOperation

- (id)init __attribute__((unavailable("init unavailable, use initWithProvider:url:objectModel")));
+ (LoginOrRegisterWithOauthOperation *)loginOrRegisterWithOauthOperationWithProvider:(NSString *)provider
																			   token:(NSString *)token;

@end
