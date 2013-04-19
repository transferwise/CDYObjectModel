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

@end

@implementation CalculationResult

+ (CalculationResult *)resultWithData:(NSDictionary *)data {
    CalculationResult *result = [[CalculationResult alloc] init];
    NSNumberFormatter *formatter = [CalculationResult moneyFormatter];
    [result setTransferwiseRate:[formatter numberFromString:data[@"transferwise_rate"]]];
    [result setTransferwiseTransferFee:[formatter numberFromString:data[@"transferwise_transfer_fee"]]];
    [result setTransferwisePayIn:[formatter numberFromString:data[@"transferwise_pay_in"]]];
    [result setTransferwisePayOut:[formatter numberFromString:data[@"transferwise_pay_out"]]];
    [result setBankRate:[formatter numberFromString:data[@"bank_rate"]]];
    [result setBankTransferFee:[formatter numberFromString:data[@"bank_transfer_fee"]]];
    [result setBankRateMarkup:[formatter numberFromString:data[@"bank_rate_markup"]]];
    [result setBankTotalFee:[formatter numberFromString:data[@"bank_total_fee"]]];
    [result setBankPayIn:[formatter numberFromString:data[@"bank_pay_in"]]];
    [result setBankPayOut:[formatter numberFromString:data[@"bank_pay_out"]]];
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

- (NSString *)transferwiseRateString {
    return [self numberStringFrom:self.transferwiseRate];
}

- (NSString *)transferwiseTransferFeeString {
    return [self numberStringFrom:self.transferwiseTransferFee];
}

- (NSString *)bankRateString {
    return [self numberStringFrom:self.bankRate];
}

- (NSString *)bankTransferFeeString {
    return [self numberStringFrom:self.bankTransferFee];
}

- (NSString *)bankPayOutString {
    return [self numberStringFrom:self.bankPayOut];
}

- (NSString *)savedAmount {
    NSNumber *number = [NSNumber numberWithFloat:([self.transferwisePayOut floatValue] - [self.bankPayOut floatValue])];
    return [self numberStringFrom:number];
}

- (NSString *)numberStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setCurrencySymbol:@""];
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

+ (NSLocale *)defaultLocale {
    return [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
}

@end
