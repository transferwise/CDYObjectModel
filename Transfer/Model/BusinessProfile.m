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
    [profile setRegistrationNumber:data[@"registration_number"]];
    [profile setDescriptionOfBusiness:data[@"description"]];
    [profile setIsDirector:data[@"is_director"]];
    [profile setAddressFirstLine:data[@"address_first_line"]];
    [profile setPostCode:data[@"post_code"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"country_code"]];
    [profile setBusinessVerified:data[@"business_verified"]];
    return profile;
}

@end
