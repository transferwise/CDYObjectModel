//
//  CurrenciesOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^CurrencyBlock)(NSError *error);


@interface CurrenciesOperation : TransferwiseOperation

@property (nonatomic, strong) CurrencyBlock resultHandler;

+ (CurrenciesOperation *)operation;

@end
