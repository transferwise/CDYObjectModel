#import "PersonalProfile.h"
#import "NSString+Validation.h"


@interface PersonalProfile ()

@end


@implementation PersonalProfile

- (BOOL)isFieldReadonly:(NSString *)fieldName {
    return [self.readonlyFields hasValue] && [self.readonlyFields rangeOfString:fieldName].location != NSNotFound;
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

- (NSDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"firstName"] = self.firstName;
    data[@"lastName"] = self.lastName;
    data[@"dateOfBirth"] = self.dateOfBirth;
    data[@"phoneNumber"] = self.phoneNumber;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    data[@"state"] = ([@"usa" caseInsensitiveCompare:self.countryCode]==NSOrderedSame && self.state)?self.state:@"";
    return [NSDictionary dictionaryWithDictionary:data];
}

- (BOOL)isFilled {
	return [self.firstName hasValue] && [self.lastName hasValue] && [self.dateOfBirth hasValue] && [self.phoneNumber hasValue]
			&& [self.addressFirstLine hasValue] && [self.postCode hasValue] && [self.city hasValue] && [self.countryCode hasValue];
}

@end
