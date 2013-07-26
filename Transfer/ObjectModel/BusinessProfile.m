#import "BusinessProfile.h"
#import "NSString+Validation.h"

@interface BusinessProfile ()

@end

@implementation BusinessProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName {
    return [self.readonlyFields hasValue] && [self.readonlyFields rangeOfString:fieldName].location != NSNotFound;
}

- (NSDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"businessName"] = self.name;
    data[@"registrationNumber"] = self.registrationNumber;
    data[@"descriptionOfBusiness"] = self.businessDescription;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    return [NSDictionary dictionaryWithDictionary:data];
}

@end
