//
//  TransferwiseClient.h
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "AFHTTPClient.h"
#import "UserDetailsOperation.h"
#import "CountriesOperation.h"
#import "CurrencyPairsOperation.h"

@class ObjectModel;

@interface TransferwiseClient : AFHTTPClient

@property (nonatomic, strong) ObjectModel *objectModel;

+ (TransferwiseClient *)sharedClient;
- (void)updateUserDetailsWithCompletionHandler:(TWProfileDetailsHandler)completion;
- (void)updateCountriesWithCompletionHandler:(CountriesResponseBlock)handler;
- (void)updateCurrencyPairsWithCompletionHandler:(CurrencyPairsBlock)handler;
- (void)clearCredentials;
- (NSString *)addTokenToPath:(NSString *)path;

@end
