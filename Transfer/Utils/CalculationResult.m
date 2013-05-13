//
//  CalculationResult.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CalculationResult.h"

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
@property (nonatomic, strong) NSDate *paymentDate;

@end

@implementation CalculationResult

+ (CalculationResult *)resultWithData:(NSDictionary *)data {
    CalculationResult *result = [[CalculationResult alloc] init];
    NSNumberFormatter *formatter = [CalculationResult moneyFormatter];
    [result setTransferwiseRate:[formatter numberFromString:data[@"transferwiseRate"]]];
    [result setTransferwiseTransferFee:[formatter numberFromString:data[@"transferwiseTransferFee"]]];
    [result setTransferwisePayIn:[formatter numberFromString:data[@"transferwisePayIn"]]];
    [result setTransferwisePayOut:[formatter numberFromString:data[@"transferwisePayOut"]]];
    [result setBankRate:[formatter numberFromString:data[@"bankRate"]]];
    [result setBankTransferFee:[formatter numberFromString:data[@"bankTransferFee"]]];
    [result setBankRateMarkup:[formatter numberFromString:data[@"bankRateMarkup"]]];
    [result setBankTotalFee:[formatter numberFromString:data[@"bankTotalFee"]]];
    [result setBankPayIn:[formatter numberFromString:data[@"bankPayIn"]]];
    [result setBankPayOut:[formatter numberFromString:data[@"bankPayOut"]]];
    [result setPaymentDate:[[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24)]];
    return result;
}

- (NSString *)formattedWinAmount {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setCurrencySymbol:[[CalculationResult defaultLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.targetCurrency]];
    return [formatter stringFromNumber:self.bankRateMarkup];
}

- (NSString *)transferwisePayInString {
    return [self numberStringFrom:self.transferwisePayIn];
}

- (NSString *)transferwisePayOutString {
    return [self numberStringFrom:self.transferwisePayOut];
}

- (NSString *)transferwisePayInStringWithCurrency {
    return [self inNumberStringFrom:self.transferwisePayIn];
}

- (NSString *)transferwisePayOutStringWithCurrency {
    return [self outNumberStringFrom:self.transferwisePayOut];
}

- (NSString *)transferwiseRateString {
    return [self rateStringFrom:self.transferwiseRate];
}

- (NSString *)transferwiseTransferFeeStringWithCurrency {
    return [self inNumberStringFrom:self.transferwiseTransferFee];
}

- (NSString *)bankRateString {
    return [self rateStringFrom:self.bankRate];
}

- (NSString *)bankTransferFeeStringWithCurrency {
    return [self outNumberStringFrom:self.bankTransferFee];
}

- (NSString *)bankPayOutStringWithCurrency{
    return [self outNumberStringFrom:self.bankPayOut];
}

- (NSString *)savedAmountWithCurrency {
    NSNumber *number = [NSNumber numberWithFloat:([self.transferwisePayOut floatValue] - [self.bankPayOut floatValue])];
    return [self outNumberStringFrom:number];
}

- (NSString *)rateStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setMinimumFractionDigits:4];
    return [formatter stringFromNumber:number];
}

- (NSString *)numberStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setCurrencySymbol:@""];
    return [formatter stringFromNumber:number];
}

- (NSString *)inNumberStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setCurrencySymbol:[[CalculationResult defaultLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.sourceCurrency]];
    return [formatter stringFromNumber:number];
}

- (NSString *)outNumberStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setCurrencySymbol:[[CalculationResult defaultLocale] displayNameForKey:NSLocaleCurrencySymbol value:self.targetCurrency]];
    return [formatter stringFromNumber:number];
}

static NSNumberFormatter *__moneyFormatter;
+ (NSNumberFormatter *)moneyFormatter {
    if (!__moneyFormatter) {
        __moneyFormatter = [[NSNumberFormatter alloc] init];
        //TODO jaanus: check this. Needed because actual user locale may require numbers containing ',' instead of '.'
        [__moneyFormatter setLocale:[CalculationResult defaultLocale]];
        [__moneyFormatter setGeneratesDecimalNumbers:YES];
    }

    return __moneyFormatter;
}

- (NSString *)paymentDateString {
    return [[CalculationResult paymentDateFormatter] stringFromDate:self.paymentDate];
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
