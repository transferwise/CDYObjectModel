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
@property (nonatomic, assign) CalculationAmountCurrency amountCurrency;
@property (nonatomic, strong, readonly) NSNumber *transferwiseRate;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, strong, readonly) NSNumber *transferwisePayIn;
@property (nonatomic, strong, readonly) NSNumber *transferwisePayOut;
@property (nonatomic, strong, readonly) NSDate *estimatedDelivery;
@property (nonatomic, copy, readonly) NSString *formattedEstimatedDelivery;
@property (nonatomic, strong, readonly) NSNumber *transferwiseTransferFee;

- (NSString *)transferwisePayInString;
- (NSString *)transferwisePayOutString;
- (NSString *)transferwisePayInStringWithCurrency;
- (NSString *)transferwisePayOutStringWithCurrency;
- (NSString *)transferwiseRateString;
- (NSString *)transferwiseTransferFeeStringWithCurrency;
- (NSString *)transferwiseCurrencyCostStringWithCurrency;
- (NSString *)bankRateString;
- (NSString *)bankTotalFeeStringWithCurrency;
- (NSString *)bankPayOutStringWithCurrency;
- (NSString *)bankPayInStringWithCurrency;
- (NSString *)receiveWinAmountWithCurrency;
- (NSString *)paymentDateString;
- (NSString *)calculatedPayWinAmountWithCurrency;
- (NSString *)payWinAmountWithCurrency;
- (BOOL)isFixedTargetPayment;
- (BOOL)isFeeZero;

+ (CalculationResult *)resultWithData:(NSDictionary *)data;
+ (NSString *)rateStringFrom:(NSNumber *)number;
+ (NSLocale *)defaultLocale;
+ (NSDateFormatter *)paymentDateFormatter;

@end
