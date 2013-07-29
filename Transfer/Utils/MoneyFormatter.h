//
//  MoneyFormatter.h
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyFormatter : NSObject

+ (MoneyFormatter *)sharedInstance;

- (NSString *)formatAmount:(NSNumber *)amount withCurrency:(NSString *)currencyCode;
- (NSString *)formatAmount:(NSNumber *)amount;
- (NSNumber *)numberFromString:(NSString *)amountString;

@end
