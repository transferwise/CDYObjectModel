//
//  CurrencyPairsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/19/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^CurrencyPairsBlock)(NSError *error);

@interface CurrencyPairsOperation : TransferwiseOperation

@property (nonatomic, copy) CurrencyPairsBlock currenciesHandler;

+ (CurrencyPairsOperation *)pairsOperation;

@end
