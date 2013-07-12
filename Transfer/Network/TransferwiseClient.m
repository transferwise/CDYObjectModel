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
#import "PlainProfileDetails.h"
#import "RemoveTokenOperation.h"

NSString *const kAPIPathBase = @"/api/v1";
//NSString *const kAPIPathBase = @"/fx-test/api/v1";

@interface TransferwiseClient ()

@property (nonatomic, strong) UserDetailsOperation *detailsOperation;
@property (nonatomic, strong) CountriesOperation *countriesOperation;
@property (nonatomic, strong) CurrencyPairsOperation *currencyOperation;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@end

@implementation TransferwiseClient

- (id)initSingleton {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api-sandbox.transferwise.com"]];
    //self = [super initWithBaseURL:[NSURL URLWithString:@"https://purple.transferwise.com"]];
    //self = [super initWithBaseURL:[NSURL URLWithString:@"http://localhost:12345"]];
    if (self) {

    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

+ (TransferwiseClient *)sharedClient {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (void)updateUserDetailsWithCompletionHandler:(TWProfileDetailsHandler)completion {
    MCLog(@"Update user details");
    UserDetailsOperation *detailsOperation = [UserDetailsOperation detailsOperation];
    [self setDetailsOperation:detailsOperation];

    [detailsOperation setCompletionHandler:^(PlainProfileDetails *result, NSError *error) {
        if (result) {
            [Credentials setDisplayName:[result displayName]];
            [Credentials setUserEmail:[result email]];
        }

        if (completion) {
            completion(result, error);
        }
    }];

    [detailsOperation execute];
}
- (void)updateCountriesWithCompletionHandler:(CountriesResponseBlock)handler {
    CountriesOperation *operation = [CountriesOperation operation];
    [self setCountriesOperation:operation];
    [operation setCompletionHandler:handler];
    [operation execute];
}

- (void)clearCredentials {
    NSString *token = [Credentials accessToken];
    [Credentials clearCredentials];
    [self clearCookies];

    RemoveTokenOperation *operation = [[RemoveTokenOperation alloc] initWithToken:token];
    [self setExecutedOperation:operation];
    [operation execute];
}

- (void)clearCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSString *domain = cookie.domain;
        if ([domain rangeOfString:@"transferwise"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        } else if ([domain rangeOfString:@"yahoo"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        } else if ([domain rangeOfString:@"google"].location != NSNotFound) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (NSString *)addTokenToPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@", kAPIPathBase, path];
}

@end
