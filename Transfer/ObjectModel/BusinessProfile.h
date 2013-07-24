#import "_BusinessProfile.h"

@interface BusinessProfile : _BusinessProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName;
- (NSDictionary *)data;

@end
