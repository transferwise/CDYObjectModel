#import "_Currency.h"

@class PlainCurrency;

@interface Currency : _Currency

- (NSString *)formattedCodeAndName;
- (PlainCurrency *)plainCurrency;

@end
