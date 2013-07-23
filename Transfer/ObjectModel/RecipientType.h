#import "_RecipientType.h"

@class PlainRecipientType;

@interface RecipientType : _RecipientType

+ (NSArray *)createPlainTypes:(NSArray *)array;
+ (PlainRecipientType *)createPlainType:(RecipientType *)type;

@end
