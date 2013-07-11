#import "_Recipient.h"

@class PlainRecipient;

@interface Recipient : _Recipient

- (NSString *)detailsRowOne;
- (NSString *)detailsRowTwo;
+ (NSArray *)createPlainRecipients:(NSArray *)recipientObjects;
- (PlainRecipient *)plainRecipient;

@end
