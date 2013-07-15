#import "BusinessProfile.h"
#import "PlainBusinessProfile.h"


@interface BusinessProfile ()

@end

@implementation BusinessProfile

- (PlainBusinessProfile *)plainProfile {
    PlainBusinessProfile *plain = [[PlainBusinessProfile alloc] init];
    [plain setBusinessName:self.name];
    [plain setRegistrationNumber:self.registrationNumber];
    [plain setDescriptionOfBusiness:self.businessDescription];
    [plain setAddressFirstLine:self.addressFirstLine];
    [plain setPostCode:self.postCode];
    [plain setCity:self.city];
    [plain setCountryCode:self.countryCode];
    return plain;
}

- (BOOL)isFieldReadonly:(NSString *)fieldName {
    return [self.readonlyFields rangeOfString:fieldName].location != NSNotFound;
}

@end
