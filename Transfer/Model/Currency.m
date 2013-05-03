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

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"Code:%@", self.code];
    [description appendString:@">"];
    return description;
}

@end
