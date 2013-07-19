#import "Currency.h"
#import "PlainCurrency.h"
#import "RecipientType.h"


@interface Currency ()

@end


@implementation Currency

- (NSString *)formattedCodeAndName {
    return [NSString stringWithFormat:@"%@ %@", self.code, self.name];
}

- (PlainCurrency *)plainCurrency {
    return [Currency createPlainCurrency:self];
}

+ (PlainCurrency *)createPlainCurrency:(Currency *)currency {
    PlainCurrency *plain = [[PlainCurrency alloc] init];
    [plain setCode:currency.code];
    [plain setName:currency.name];
    [plain setDefaultRecipientType:currency.defaultRecipientType.type];
    [plain setRecipientTypes:[RecipientType typeCodesArray:currency.recipientTypes]];
    return plain;
}

@end
