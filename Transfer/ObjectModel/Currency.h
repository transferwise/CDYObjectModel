#import "_Currency.h"

@class RecipientType;

@interface Currency : _Currency

- (NSString *)formattedCodeAndName;
- (BOOL)isBicRequiredForType:(RecipientType*)type;
@end
