//
//  PlainPersonalProfile.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainPersonalProfile.h"
#import "NSString+Validation.h"
#import "PlainPersonalProfileInput.h"

@interface PlainPersonalProfile ()

@end

@implementation PlainPersonalProfile

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

- (PlainPersonalProfileInput *)input {
    PlainPersonalProfileInput *profile = [[PlainPersonalProfileInput alloc] init];
    [profile setFullName:self.fullName];
    [profile setFirstName:self.firstName];
    [profile setLastName:self.lastName];
    [profile setDateOfBirthString:self.dateOfBirthString];
    [profile setPhoneNumber:self.phoneNumber];
    [profile setAddressFirstLine:self.addressFirstLine];
    [profile setPostCode:self.postCode];
    [profile setCity:self.city];
    [profile setCountryCode:self.countryCode];
    return profile;
}

@end
