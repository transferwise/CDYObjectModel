#import "_PersonalProfile.h"

@interface PersonalProfile : _PersonalProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName;
- (NSString *)fullName;
- (NSDictionary *)data;

@end
