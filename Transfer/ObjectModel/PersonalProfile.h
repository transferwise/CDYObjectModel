#import "_PersonalProfile.h"

@class PlainPersonalProfile;

@interface PersonalProfile : _PersonalProfile

- (PlainPersonalProfile *)plainProfile;
- (BOOL)isFieldReadonly:(NSString *)fieldName;

@end
