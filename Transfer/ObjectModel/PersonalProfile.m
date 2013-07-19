#import "PersonalProfile.h"
#import "PlainPersonalProfile.h"
#import "NSString+Validation.h"


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

- (NSString *)fullName {
    NSMutableString *result = [NSMutableString string];
    if ([self.firstName hasValue]) {
        [result appendString:self.firstName];
    }

    if ([self.firstName hasValue] && [self.lastName hasValue]) {
        [result appendString:@" "];
    }

    if ([self.lastName hasValue]) {
        [result appendString:self.lastName];
    }

    return [NSString stringWithString:result];
}

@end
