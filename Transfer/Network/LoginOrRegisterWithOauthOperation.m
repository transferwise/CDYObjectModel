//
//  LoginOrRegisterWithOauthOperation.m
//  Transfer
//
//  Created by Juhan Hion on 25.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "LoginOrRegisterWithOauthOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"

NSString *const kOauthPath = @"/account/loginOrRegisterWithOauth";

@interface LoginOrRegisterWithOauthOperation ()

@property (nonatomic, strong) NSString* provider;
@property (nonatomic, strong) NSString* token;

@end

@implementation LoginOrRegisterWithOauthOperation

- (instancetype)initWithProvider:(NSString *)provider
						   token:(NSString *)token
{
	self = [super init];
	if (self)
	{
		self.provider = provider;
		self.token = token;
	}
	return self;
}

+ (LoginOrRegisterWithOauthOperation *)loginOrRegisterWithOauthOperationWithProvider:(NSString *)provider
																			   token:(NSString *)token
{
	return [[LoginOrRegisterWithOauthOperation alloc] initWithProvider:provider
																 token:token];
}

- (void)execute
{
	MCLog(@"execute");
	
	NSString *path = [self addTokenToPath:kOauthPath];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	params[@"provider"] = self.provider;
	params[@"token"] = self.token;
	
	__block __weak LoginOrRegisterWithOauthOperation *weakSelf = self;
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		
	}];
	
	[self setOperationErrorHandler:^(NSError *error) {
		
	}];
	
	[self postData:params toPath:path];
}

@end
