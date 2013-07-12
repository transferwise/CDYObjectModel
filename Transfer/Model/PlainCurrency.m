//
//  PlainCurrency.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainCurrency.h"

@interface PlainCurrency ()

@property (nonatomic, assign) BOOL fixedTargetPaymentAllowed;
@property (nonatomic, strong) NSNumber *maxInvoiceAmount;
@property (nonatomic, strong) NSNumber *minInvoiceAmount;
@property (nonatomic, copy) NSString *symbol;

@end

@implementation PlainCurrency

+ (PlainCurrency *)currencyWithSourceData:(NSDictionary *)data {
    PlainCurrency *currency = [[PlainCurrency alloc] init];
    [currency setCode:data[@"currencyCode"]];
    [currency setMaxInvoiceAmount:data[@"maxInvoiceAmount"]];

    NSArray *targetCurrencies = data[@"targetCurrencies"];
    NSMutableArray *targets = [NSMutableArray arrayWithCapacity:[targetCurrencies count]];
    for (NSDictionary *targetData in targetCurrencies) {
        PlainCurrency *target = [PlainCurrency currencyWithTargetData:targetData];
        [targets addObject:target];
    }

    [currency setTargets:[NSArray arrayWithArray:targets]];

    return currency;
}

+ (PlainCurrency *)currencyWithTargetData:(NSDictionary *)data {
    PlainCurrency *target = [[PlainCurrency alloc] init];
    [target setCode:data[@"currencyCode"]];
    [target setMinInvoiceAmount:data[@"minInvoiceAmount"]];
    [target setFixedTargetPaymentAllowed:[data[@"fixedTargetPaymentAllowed"] boolValue]];
    return target;
}

+ (PlainCurrency *)currencyWithCode:(NSString *)code {
    PlainCurrency *currency = [[PlainCurrency alloc] init];
    [currency setCode:code];
    return currency;
}

+ (PlainCurrency *)currencyWithRecipientData:(NSDictionary *)data {
    PlainCurrency *currency = [[PlainCurrency alloc] init];
    [currency setCode:data[@"code"]];
    [currency setSymbol:data[@"symbol"]];
    [currency setName:data[@"name"]];
    [currency setDefaultRecipientType:data[@"defaultRecipientType"]];
    [currency setRecipientTypes:data[@"recipientTypes"]];
    return currency;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"Code:%@", self.code];
    [description appendString:@">"];
    return description;
}

- (NSString *)formattedCodeAndName {
    return [NSString stringWithFormat:@"%@ %@", self.code, self.name];
}

@end
