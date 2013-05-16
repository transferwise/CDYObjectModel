//
//  MoneyFormatter.h
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyFormatter : NSNumberFormatter

+ (MoneyFormatter *)sharedInstance;

- (NSString *)formatAmount:(NSNumber *)amount withCurrency:(NSString *)currencyCode;

@end
