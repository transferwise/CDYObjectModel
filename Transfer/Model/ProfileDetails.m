//
//  ProfileDetails.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileDetails.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"

@interface ProfileDetails ()

@property (nonatomic, copy) NSString *reference;

@end

@implementation ProfileDetails

- (NSString *)displayName {
    return self.personalProfile ? [self.personalProfile fullName] : self.email;
}

+ (ProfileDetails *)detailsWithData:(NSDictionary *)data {
    ProfileDetails *details = [[ProfileDetails alloc] init];
    [details setEmail:data[@"email"]];
    [details setReference:data[@"pReference"]];
    NSDictionary *personalProfileData = data[@"personalProfile"];
    if (personalProfileData && [personalProfileData class] != [NSNull class]) {
        PersonalProfile *profile = [PersonalProfile profileWithData:personalProfileData];
        [details setPersonalProfile:profile];
    }
    NSDictionary *businessProfileData = data[@"businessProfile"];
    if (businessProfileData && [businessProfileData class] != [NSNull class]) {
        BusinessProfile *profile = [BusinessProfile profileWithData:businessProfileData];
        [details setBusinessProfile:profile];
    }
    return details;
}

@end
