#import "_Recipient.h"

@class PlainRecipient;
@class RecipientTypeField;

@interface Recipient : _Recipient

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
+ (NSArray *)createPlainRecipients:(NSArray *)recipientObjects;
- (PlainRecipient *)plainRecipient;
- (NSString *)valueField:(RecipientTypeField *)field;

@end
