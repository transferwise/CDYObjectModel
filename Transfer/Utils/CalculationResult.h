//
//  CalculationResult.h
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferCalculationsOperation.h"

@interface CalculationResult : NSObject

@property (nonatomic, copy) NSString *sourceCurrency;
@property (nonatomic, copy) NSString *targetCurrency;
@property (nonatomic) CalculationAmountCurrency amountCurrency;

+ (CalculationResult *)resultWithData:(NSDictionary *)data;

- (NSString *)formattedWinAmount;
- (NSString *)transferwisePayInString;
- (NSString *)transferwisePayOutString;
+ (NSLocale *)defaultLocale;

@end
