#import "_Recipient.h"

@class RecipientTypeField;

@interface Recipient : _Recipient

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
- (NSString *)valueField:(RecipientTypeField *)field;
- (void)setValue:(NSString *)value forField:(RecipientTypeField *)field;
- (NSDictionary *)data;

@end
