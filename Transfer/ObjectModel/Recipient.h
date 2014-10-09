#import "_Recipient.h"

@class RecipientTypeField;

@interface Recipient : _Recipient

//currently used to cache AddressBook images, in future api might provide this as well
@property (strong, nonatomic) UIImage* image;

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
- (NSString *)valueForFieldNamed:(NSString*)fieldName;
- (NSString *)valueField:(RecipientTypeField *)field;
- (NSString *)presentationStringFromAllValues;
- (void)setValue:(NSString *)value forField:(RecipientTypeField *)field;
- (NSDictionary *)data;
- (BOOL)hasAddress;

@end
