//
//  PlainBusinessProfile.m
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainBusinessProfile.h"
#import "PlainBusinessProfileInput.h"

@interface PlainBusinessProfile ()

@property (nonatomic, strong) NSNumber* isDirector;
@property (nonatomic, strong) NSNumber* businessVerified;

@end

@implementation PlainBusinessProfile

+(PlainBusinessProfile *)profileWithData:(NSDictionary *)data
{
    PlainBusinessProfile *profile = [[PlainBusinessProfile alloc] init];
    [profile setBusinessName:data[@"name"]];
    [profile setRegistrationNumber:data[@"registrationNumber"]];
    [profile setDescriptionOfBusiness:data[@"description"]];
    [profile setIsDirector:data[@"isDirector"]];
    [profile setAddressFirstLine:data[@"addressFirstLine"]];
    [profile setPostCode:data[@"postCode"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"countryCode"]];
    [profile setBusinessVerified:data[@"businessVerified"]];
    return profile;
}

- (BOOL)businessVerifiedValue {
    return [self.businessVerified boolValue];
}

- (PlainBusinessProfileInput *)input {
    PlainBusinessProfileInput *input = [[PlainBusinessProfileInput alloc] init];
    [input setBusinessName:self.businessName];
    [input setRegistrationNumber:self.registrationNumber];
    [input setDescriptionOfBusiness:self.descriptionOfBusiness];
    [input setAddressFirstLine:self.addressFirstLine];
    [input setPostCode:self.postCode];
    [input setCity:self.city];
    [input setCountryCode:self.countryCode];
    return input;
}

@end
