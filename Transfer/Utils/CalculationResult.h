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
- (NSString *)transferwisePayInStringWithCurrency;
- (NSString *)transferwisePayOutStringWithCurrency;
- (NSString *)transferwiseRateString;
- (NSString *)transferwiseTransferFeeStringWithCurrency;
- (NSString *)bankRateString;
- (NSString *)bankTransferFeeStringWithCurrency;
- (NSString *)bankPayOutStringWithCurrency;
- (NSString *)savedAmountWithCurrency;

+ (NSLocale *)defaultLocale;

@end
