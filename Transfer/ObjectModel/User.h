#import "_User.h"

@class PlainProfileDetails;

@interface User : _User

- (PlainProfileDetails *)plainUserDetails;
- (NSString *)displayName;

@end
