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
@property (nonatomic, strong, readonly) NSNumber *transferwiseRate;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong, readonly) NSNumber *transferwisePayIn;

+ (CalculationResult *)resultWithData:(NSDictionary *)data;

- (NSString *)transferwisePayInString;
- (NSString *)transferwisePayOutString;
- (NSString *)transferwisePayInStringWithCurrency;
- (NSString *)transferwisePayOutStringWithCurrency;
- (NSString *)transferwiseRateString;
- (NSString *)transferwiseTransferFeeStringWithCurrency;
- (NSString *)transferwiseCurrencyCostStringWithCurrency;
- (NSString *)bankRateString;
- (NSString *)bankTransferFeeStringWithCurrency;
- (NSString *)bankTotalFeeStringWithCurrency;
- (NSString *)bankPayOutStringWithCurrency;
- (NSString *)bankPayInStringWithCurrency;
- (NSString *)receiveWinAmountWithCurrency;
- (NSString *)paymentDateString;
- (NSString *)payWinAmountWithCurrency;

@end
