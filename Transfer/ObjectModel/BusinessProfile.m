#import "BusinessProfile.h"
#import "NSString+Validation.h"

@interface BusinessProfile ()

@end

@implementation BusinessProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName
{
    return [self.readonlyFields hasValue] && [self.readonlyFields rangeOfString:fieldName].location != NSNotFound;
}

- (NSDictionary *)data
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"businessName"] = self.name;
    data[@"registrationNumber"] = self.registrationNumber;
    data[@"descriptionOfBusiness"] = self.businessDescription;
	data[@"companyRole"] = self.companyRole;
	data[@"companyType"] = self.companyType;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    data[@"state"] = ([@"usa" caseInsensitiveCompare:self.countryCode]==NSOrderedSame && self.state)?self.state:@"";
    return [NSDictionary dictionaryWithDictionary:data];
}

- (BOOL)isFilled
{
	return [self.name hasValue] && [self.registrationNumber hasValue] && [self.registrationNumber hasValue]
	&& [self.businessDescription hasValue] && [self.companyRole hasValue] && [self.companyType hasValue]
	&& [self.addressFirstLine hasValue] && [self.postCode hasValue] && [self.city hasValue] && [self.countryCode hasValue];
}

@end
