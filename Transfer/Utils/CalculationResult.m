//
//  CalculationResult.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CalculationResult.h"
#import "MoneyFormatter.h"

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
    NSNumberFormatter *formatter = [CalculationResult moneyReadFormatter];
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
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankRateMarkup withCurrency:self.targetCurrency];
}

- (NSString *)transferwisePayInString {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwisePayIn];
}

- (NSString *)transferwisePayOutString {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwisePayOut];
}

- (NSString *)transferwisePayInStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.transferwisePayIn withCurrency:self.sourceCurrency];
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

- (NSString *)bankRateString {
    return [self rateStringFrom:self.bankRate];
}

- (NSString *)bankTransferFeeStringWithCurrency {
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankTransferFee withCurrency:self.targetCurrency];
}

- (NSString *)bankPayOutStringWithCurrency{
    return [[MoneyFormatter sharedInstance] formatAmount:self.bankPayOut withCurrency:self.targetCurrency];
}

- (NSString *)savedAmountWithCurrency {
    NSNumber *number = [NSNumber numberWithFloat:([self.transferwisePayOut floatValue] - [self.bankPayOut floatValue])];
    return [[MoneyFormatter sharedInstance] formatAmount:number withCurrency:self.targetCurrency];
}

- (NSString *)rateStringFrom:(NSNumber *)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[CalculationResult defaultLocale]];
    [formatter setMinimumFractionDigits:4];
    return [formatter stringFromNumber:number];
}

static NSNumberFormatter *__moneyFormatter;
+ (NSNumberFormatter *)moneyReadFormatter {
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
