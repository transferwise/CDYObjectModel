#import "_Recipient.h"

@class RecipientTypeField;

@interface Recipient : _Recipient

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
- (NSString *)valueField:(RecipientTypeField *)field;
- (NSString *)presentationStringFromAllValues;
- (void)setValue:(NSString *)value forField:(RecipientTypeField *)field;
- (NSDictionary *)data;
- (BOOL)hasAddress;
@end
