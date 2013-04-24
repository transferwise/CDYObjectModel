//
//  PersonalProfile.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfile.h"
#import "NSString+Validation.h"

@interface PersonalProfile ()

@property (nonatomic, strong) NSNumber *identityVerified;
@property (nonatomic, strong) NSNumber *addressVerified;

@end

@implementation PersonalProfile

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

+ (PersonalProfile *)profileWithData:(NSDictionary *)data {
    PersonalProfile *profile = [[PersonalProfile alloc] init];
    [profile setFirstName:data[@"first_name"]];
    [profile setLastName:data[@"last_name"]];
    [profile setDateOfBirthString:data[@"date_of_birth"]];
    [profile setPhoneNumber:data[@"phone_number"]];
    [profile setAddressFirstLine:data[@"address_first_line"]];
    [profile setPostCode:data[@"post_code"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"country_code"]];
    [profile setIdentityVerified:data[@"identity_verified"]];
    [profile setAddressVerified:data[@"address_verified"]];
    return profile;
}

@end
