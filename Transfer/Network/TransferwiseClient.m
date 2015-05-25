//
//  TransferwiseClient.m
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseClient.h"
#import "Constants.h"
#import "Credentials.h"
#import "RemoveTokenOperation.h"
#import "ObjectModel+Users.h"
#import "CompanyAttributesOperation.h"

NSString *const kAPIPathBase = @"/api";

@interface TransferwiseClient ()

@property (nonatomic, strong) UserDetailsOperation *detailsOperation;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) CompanyAttributesOperation *companyAttributesOperation;

@end

@implementation TransferwiseClient

- (id)initSingleton
{
    self = [super initWithBaseURL:[NSURL URLWithString:TRWServerAddress]];
    if (self)
	{
        self.operationQueue.maxConcurrentOperationCount = TRW_MAX_CONCURRENT_OPERATIONS;
    }

    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

+ (TransferwiseClient *)sharedClient
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (void)updateUserDetailsWithCompletionHandler:(TWProfileDetailsHandler)completion
{
    MCLog(@"Update user details");
    if (![Credentials userLoggedIn])
	{
        MCLog(@"User not logged in.");
        return;
    }

    UserDetailsOperation *detailsOperation = [UserDetailsOperation detailsOperation];
    [self setDetailsOperation:detailsOperation];
    [detailsOperation setObjectModel:self.objectModel];

    [detailsOperation setCompletionHandler:^(NSError *error) {
        if (completion)
		{
            completion(error);
        }
    }];

    [detailsOperation execute];
}

- (void)clearCredentials
{
    NSString *token = [Credentials accessToken];
    RemoveTokenOperation *operation = [[RemoveTokenOperation alloc] initWithToken:token];
    [operation setObjectModel:self.objectModel];
    [self setExecutedOperation:operation];
    [operation execute];
}

+ (void)clearCookies
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies)
	{
        NSString *domain = cookie.domain;
        if ([domain rangeOfString:@"transferwise"].location != NSNotFound)
		{
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (NSString *)addTokenToPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", kAPIPathBase, path];
}

- (void)updateBaseData
{
    dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TRWWillUpdateBaseDataNotification
															object:nil];
        if (self.companyAttributesOperation)
		{
            return;
        }

		CompanyAttributesOperation *operation = [CompanyAttributesOperation operation];
        [self setCompanyAttributesOperation:operation];
        [operation setObjectModel:self.objectModel];
        [operation setResultHandler:^(NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCompanyAttributesOperation:nil];
				[[NSNotificationCenter defaultCenter] postNotificationName:TRWDidUpdateBaseDataNotification
																	object:nil];
            });
        }];
        [operation execute];
    });
}

- (void)setBasicUsername:(NSString *)username
				password:(NSString *)password
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:username password:password];
}

@end
