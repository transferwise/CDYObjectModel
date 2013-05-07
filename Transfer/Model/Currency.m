//
//  Currency.m
//  Transfer
//
//  Created by Jaanus Siim on 5/2/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Currency.h"

@interface Currency ()

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSArray *targets;
@property (nonatomic, assign) BOOL fixedTargetPaymentAllowed;
@property (nonatomic, strong) NSNumber *maxInvoiceAmount;
@property (nonatomic, strong) NSNumber *minInvoiceAmount;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *defaultRecipientType;
@property (nonatomic, strong) NSArray *recipientTypes;

@end

@implementation Currency

+ (Currency *)currencyWithSourceData:(NSDictionary *)data {
    Currency *currency = [[Currency alloc] init];
    [currency setCode:data[@"currency_code"]];
    [currency setMaxInvoiceAmount:data[@"max_invoice_amount"]];

    NSArray *targetCurrencies = data[@"target_currencies"];
    NSMutableArray *targets = [NSMutableArray arrayWithCapacity:[targetCurrencies count]];
    for (NSDictionary *targetData in targetCurrencies) {
        Currency *target = [Currency currencyWithTargetData:targetData];
        [targets addObject:target];
    }

    [currency setTargets:[NSArray arrayWithArray:targets]];

    return currency;
}

+ (Currency *)currencyWithTargetData:(NSDictionary *)data {
    Currency *target = [[Currency alloc] init];
    [target setCode:data[@"currency_code"]];
    [target setMinInvoiceAmount:data[@"min_invoice_amount"]];
    [target setFixedTargetPaymentAllowed:[data[@"fixed_target_payment_allowed"] boolValue]];
    return target;
}

+ (Currency *)currencyWithCode:(NSString *)code {
    Currency *currency = [[Currency alloc] init];
    [currency setCode:code];
    return currency;
}

+ (Currency *)currencyWithRecipientData:(NSDictionary *)data {
    Currency *currency = [[Currency alloc] init];
    [currency setCode:data[@"code"]];
    [currency setSymbol:data[@"symbol"]];
    [currency setName:data[@"name"]];
    [currency setDefaultRecipientType:data[@"default_recipient_type"]];
    [currency setRecipientTypes:data[@"recipient_types"]];
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
