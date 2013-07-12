//
//  MoneyFormatter.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyFormatter.h"
#import "Constants.h"

@interface MoneyFormatter ()

@property (nonatomic, strong) NSNumberFormatter *formatterWithCurrency;
@property (nonatomic, strong) NSNumberFormatter *formatterWithoutCurrency;

@end

@implementation MoneyFormatter

+ (MoneyFormatter *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        MoneyFormatter *formatter = [[self alloc] initSingleton];
        return formatter;
    });
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (id)initSingleton {
    self = [super init];
    if (self) {
       _formatterWithCurrency = [[NSNumberFormatter alloc] init];
        [_formatterWithCurrency setGeneratesDecimalNumbers:YES];
        [_formatterWithCurrency setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_formatterWithCurrency setCurrencyDecimalSeparator:@"."];
        [_formatterWithCurrency setCurrencyGroupingSeparator:@" "];

        _formatterWithoutCurrency = [[NSNumberFormatter alloc] init];
        [_formatterWithoutCurrency setGeneratesDecimalNumbers:YES];
        [_formatterWithoutCurrency setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_formatterWithoutCurrency setCurrencyDecimalSeparator:@"."];
        [_formatterWithoutCurrency setCurrencySymbol:@""];
        [_formatterWithoutCurrency setCurrencyGroupingSeparator:@" "];
    }

    return self;
}

- (NSString *)formatAmount:(NSNumber *)amount withCurrency:(NSString *)currencyCode {
    [self.formatterWithCurrency setCurrencyCode:currencyCode];
    return [self.formatterWithCurrency stringFromNumber:amount];
}

- (NSString *)formatAmount:(NSNumber *)amount {
    return [self.formatterWithoutCurrency stringFromNumber:amount];
}

@end
