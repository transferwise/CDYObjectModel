#import "_User.h"

@interface User : _User

- (NSString *)displayName;
- (PersonalProfile *)personalProfileObject;
- (BusinessProfile *)businessProfileObject;
- (BOOL)personalProfileFilled;
- (BOOL)businessProfileFilled;
- (NSInteger)deducedId;

@end
