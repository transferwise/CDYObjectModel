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

@end

@implementation PlainBusinessProfile

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
