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
#import "ProfileDetails.h"
#import "CurrencyPairsOperation.h"

@interface TransferwiseClient ()

@property (nonatomic, strong) UserDetailsOperation *detailsOperation;
@property (nonatomic, strong) CountriesOperation *countriesOperation;
@property (nonatomic, strong) CurrencyPairsOperation *currencyOperation;

@end

@implementation TransferwiseClient

- (id)initSingleton {
    self = [super initWithBaseURL:[NSURL URLWithString:@"https://api-sandbox.transferwise.com"]];
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

    [detailsOperation setCompletionHandler:^(ProfileDetails *result, NSError *error) {
        if (result) {
            [Credentials setDisplayName:[result displayName]];
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

- (void)updateCurrencyPairsWithCompletionHandler:(CurrencyPairsBlock)handler {
    MCLog(@"Update pairs");
    CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
    [self setCurrencyOperation:operation];
    [operation setCurrenciesHandler:handler];

    [operation setObjectModel:self.objectModel];
    [operation execute];
}

@end
