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
#import "ObjectModel+Users.h"
#import "ReferralsCoordinator.h"

NSString *const kOauthPath = @"/account/loginOrRegisterWithOauth";

@interface LoginOrRegisterWithOauthOperation ()

@property (nonatomic, strong) NSString* provider;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic) BOOL keepPendingPayment;

@end

@implementation LoginOrRegisterWithOauthOperation

@dynamic objectModel;

- (instancetype)initWithProvider:(NSString *)provider
						   token:(NSString *)token
					 objectModel:(ObjectModel *)objectModel
			  keepPendingPayment:(BOOL)keepPendingPayment
{
	self = [super init];
	if (self)
	{
		self.provider = provider;
		self.token = token;
		self.objectModel = objectModel;
		self.keepPendingPayment = keepPendingPayment;
	}
	return self;
}

+ (LoginOrRegisterWithOauthOperation *)loginOrRegisterWithOauthOperationWithProvider:(NSString *)provider
																			   token:(NSString *)token
																		 objectModel:(ObjectModel *)objectModel
																  keepPendingPayment:(BOOL)keepPendingPayment
{
	return [[LoginOrRegisterWithOauthOperation alloc] initWithProvider:provider
																 token:token
														   objectModel:objectModel
													keepPendingPayment:keepPendingPayment];
}

- (void)execute
{
	MCLog(@"execute");
	
	NSString *path = [self addTokenToPath:kOauthPath];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	params[@"provider"] = self.provider;
	params[@"token"] = self.token;
    
    NSString* referrer = [ReferralsCoordinator referralToken];
    if(referrer)
    {
        params[TRWReferralTokenKey] = referrer;
    }
    NSString* source = [ReferralsCoordinator referralSource];
    if(source)
    {
        params[TRWReferralSourceKey] = source;
    }

	
	//Ensure no stale data is present before logging in.
	[self.objectModel clearUserRelatedDataKeepingPendingPayment:self.keepPendingPayment];
	
	__block __weak LoginOrRegisterWithOauthOperation *weakSelf = self;
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		weakSelf.responseHandler(nil, response);
	}];
	
	[self setOperationErrorHandler:^(NSError *error) {
		MCLog(@"Error:%@", error);
		weakSelf.responseHandler(error, nil);
	}];
	
	[self postData:params toPath:path];
}

@end
