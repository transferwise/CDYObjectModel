#import "_BusinessProfile.h"

@class PlainBusinessProfile;

@interface BusinessProfile : _BusinessProfile

- (PlainBusinessProfile *)plainProfile;
- (BOOL)isFieldReadonly:(NSString *)fieldName;

@end
