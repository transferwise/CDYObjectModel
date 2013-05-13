//
//  BusinessProfile.m
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfile.h"

@interface BusinessProfile ()

@property (nonatomic, strong) NSNumber* isDirector;
@property (nonatomic, strong) NSNumber* businessVerified;

@end

@implementation BusinessProfile

+(BusinessProfile*)profileWithData:(NSDictionary *)data
{
    BusinessProfile *profile = [[BusinessProfile alloc] init];
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

@end
