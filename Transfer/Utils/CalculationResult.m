//
//  CalculationResult.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CalculationResult.h"
#import "MoneyFormatter.h"
#import "NSDate+ServerTime.h"

@interface CalculationResult ()

@property (nonatomic, strong) NSNumber *transferwiseRate;
@property (nonatomic, strong) NSNumber *transferwiseTransferFee;
@property (nonatomic, strong) NSNumber *transferwisePayIn;
@property (nonatomic, strong) NSNumber *transferwisePayOut;
@property (nonatomic, strong) NSNumber *bankRate;
@property (nonatomic, strong) NSNumber *bankTransferFee;
@property (nonatomic, strong) NSNumber *bankRateMarkup;
@property (nonatomic, strong) NSNumber *bankTotalFee;
@property (nonatomic, strong) NSNumber *bankPayIn;
@property (nonatomic, strong) NSNumber *bankPayOut;
@property (nonatomic, strong) NSDate *estimatedDelivery;
@property (nonatomic, strong) NSNumber *transferwiseRefund;

@end

@implementation CalculationResult

+ (CalculationResult *)resultWithData:(NSDictionary *)data {
    CalculationResult *result = [[CalculationResult alloc] init];
    [result setTransferwiseRate:data[@"transferwiseRate"]];
    [result setTransferwiseTransferFee:data[@"transferwiseTransferFee"]];
    [result setTransferwisePayIn:data[@"transferwisePayIn"]];
    [result setTransferwisePayOut:data[@"transferwisePayOut"]];
    [result setBankRate:data[@"bankRate"]];
    [result setBankTransferFee:data[@"bankTransferFee"]];
    [result setBankRateMarkup:data[@"bankRateMarkup"]];
    [result setBankTotalFee:data[@"bankTotalFee"]];
    [result setBankPayIn:data[@"bankPayIn"]];
    [result setBankPayOut:data[@"bankPayOut"]];
    [result setTransferwiseRefund:data[@"transferwiseRefund"]];
    [result setEstimatedDelivery:[NSDate dateFromServerString:data[@"estimatedDelivery"]]];
    return result;
}

- (NSString *)transferwisePayInString {
    return [[MoneyFormatter sharedInstance] formatAmount:[self transferwisePayInAmount]];
}

- (NSString *)transferwisePayOutString {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwisePayOut];
}

- (NSString *)transferwisePayInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:[self transferwisePayInAmount] withCurrency:self.sourceCurrency];
}

- (NSNumber *)transferwisePayInAmount {
    if (self.amountCurrency == SourceCurrency) {
        return self.transferwisePayIn;
    }

    return [NSNumber numberWithFloat:[self.transferwisePayIn floatValue] - [self.transferwiseRefund floatValue]];
}

- (NSString *)transferwisePayOutStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwisePayOut withCurrency:self.targetCurrency];
}

- (NSString *)transferwiseRateString {
    return [self rateStringFrom:self.transferwiseRate];
}

- (NSString *)transferwiseTransferFeeStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwiseTransferFee withCurrency:self.sourceCurrency];
}

- (NSString *)transferwiseCurrencyCostStringWithCurrency {
    NSNumber *cost = [NSNumber numberWithFloat:[self.transferwisePayInAmount floatValue] - [self.transferwiseTransferFee floatValue]];
    return [[MoneyFormatter sharedInstance] formatAmount:cost withCurrency:self.sourceCurrency];
}


- (NSString *)bankRateString {
    return [self rateStringFrom:self.bankRate];
}

- (NSString *)bankTotalFeeStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankTotalFee withCurrency:self.targetCurrency];
}

- (NSString *)bankPayOutStringWithCurrency{
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankPayOut withCurrency:self.targetCurrency];
}

- (NSString *)bankPayInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankPayIn withCurrency:self.sourceCurrency];
}

- (NSString *)receiveWinAmountWithCurrency {
    NSNumber *number = [NSNumber numberWithFloat:([self.transferwisePayOut floatValue] - [self.bankPayOut floatValue])];
    return [[MoneyFormatter sharedInstance] formatAmount:number withCurrency:self.targetCurrency];
}

NSNumberFormatter *__formatter;
- (NSString *)rateStringFrom:(NSNumber *)number {
    if (!__formatter) {
        __formatter = [[NSNumberFormatter alloc] init];
        [__formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [__formatter setLocale:[CalculationResult defaultLocale]];
        [__formatter setMinimumFractionDigits:4];
    }

    return [__formatter stringFromNumber:number];
}

- (NSString *)paymentDateString {
    return [[CalculationResult paymentDateFormatter] stringFromDate:self.estimatedDelivery];
}

- (NSString *)payWinAmountWithCurrency {
    NSNumber *win = [NSNumber numberWithFloat:([self.bankPayIn floatValue] - [self.transferwisePayIn floatValue] + [self.transferwiseRefund floatValue])];
    return [[MoneyFormatter sharedInstance] formatAmount:win withCurrency:self.sourceCurrency];
}


+ (NSLocale *)defaultLocale {
    return [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
}

NSDateFormatter *__paymentDateFormatter;
+ (NSDateFormatter *)paymentDateFormatter {
    if (!__paymentDateFormatter) {
        __paymentDateFormatter = [[NSDateFormatter alloc] init];
        [__paymentDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [__paymentDateFormatter setDateStyle:NSDateFormatterFullStyle];
    }

    return __paymentDateFormatter;
}


@end
