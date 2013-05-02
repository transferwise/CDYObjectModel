//
//  ObjectModel+CurrencyPairs.h
//  Transfer
//
//  Created by Jaanus Siim on 4/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class CurrencyPair;

@interface ObjectModel (CurrencyPairs)

- (NSArray *)listAllCurrencyPairs;
- (void)addPairWithData:(NSDictionary *)data;
- (CurrencyPair *)defaultPair;

@end
