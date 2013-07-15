#import "PersonalProfile.h"
#import "PlainPersonalProfile.h"


@interface PersonalProfile ()

@end


@implementation PersonalProfile

- (PlainPersonalProfile *)plainProfile {
    PlainPersonalProfile *plain = [[PlainPersonalProfile alloc] init];
    [plain setFirstName:self.firstName];
    [plain setLastName:self.lastName];
    [plain setDateOfBirthString:self.dateOfBirth];
    [plain setPhoneNumber:self.phoneNumber];
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
