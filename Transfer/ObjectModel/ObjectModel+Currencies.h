//
//  ObjectModel+Currencies.h
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class Currency;

@interface ObjectModel (Currencies)

- (Currency *)currencyWithCode:(NSString *)code;
- (void)createOrUpdateCurrencyWithData:(NSDictionary *)data index:(NSUInteger)index;

@end
