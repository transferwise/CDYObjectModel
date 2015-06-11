//
//  LoginOrRegisterWithOauthOperation.h
//  Transfer
//
//  Created by Juhan Hion on 25.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "LoginOperation.h"

@interface LoginOrRegisterWithOauthOperation : TransferwiseOperation

@property (nonatomic, copy) LoginResponseBlock responseHandler;

- (id)init __attribute__((unavailable("init unavailable, use initWithProvider:token:objectModel:keepPendingPayment:")));
+ (LoginOrRegisterWithOauthOperation *)loginOrRegisterWithOauthOperationWithProvider:(NSString *)provider
																			   token:(NSString *)token
																			   email:(NSString *)email
																		 objectModel:(ObjectModel *)objectModel
																  keepPendingPayment:(BOOL)keepPendingPayment;

@end
