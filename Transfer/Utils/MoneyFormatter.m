//
//  MoneyFormatter.m
//  Transfer
//
//  Created by Jaanus Siim on 5/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyFormatter.h"
#import "Constants.h"

@implementation MoneyFormatter

+ (MoneyFormatter *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        MoneyFormatter *formatter = [[self alloc] initSingleton];
        [formatter setGeneratesDecimalNumbers:YES];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
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
        // Custom initialization code
    }
    return self;
}

- (NSString *)formatAmount:(NSNumber *)amount withCurrency:(NSString *)currencyCode {
    [self setCurrencyCode:currencyCode];

    return [self stringFromNumber:amount];
}

@end
