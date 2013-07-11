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

@property (nonatomic, strong) NSNumber *identityVerified;
@property (nonatomic, strong) NSNumber *addressVerified;

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

+ (PlainPersonalProfile *)profileWithData:(NSDictionary *)data {
    PlainPersonalProfile *profile = [[PlainPersonalProfile alloc] init];
    [profile setFirstName:data[@"firstName"]];
    [profile setLastName:data[@"lastName"]];
    [profile setDateOfBirthString:data[@"dateOfBirth"]];
    [profile setPhoneNumber:data[@"phoneNumber"]];
    [profile setAddressFirstLine:data[@"addressFirstLine"]];
    [profile setPostCode:data[@"postCode"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"countryCode"]];
    [profile setIdentityVerified:data[@"identityVerified"]];
    [profile setAddressVerified:data[@"addressVerified"]];
    return profile;
}

- (BOOL)identityVerifiedValue {
    return [self.identityVerified boolValue];
}

- (BOOL)addressVerifiedValue {
    return [self.addressVerified boolValue];
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
