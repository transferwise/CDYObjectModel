//
//  ProfileDetails.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileDetails.h"
#import "PersonalProfile.h"

@interface ProfileDetails ()

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *reference;

@property (nonatomic, strong) PersonalProfile *personalProfile;

@end

@implementation ProfileDetails

- (NSString *)displayName {
    return self.personalProfile ? [self.personalProfile fullName] : self.email;
}

+ (ProfileDetails *)detailsWithData:(NSDictionary *)data {
    ProfileDetails *details = [[ProfileDetails alloc] init];
    [details setEmail:data[@"email"]];
    [details setReference:data[@"p_reference"]];
    NSDictionary *personalProfileData = data[@"personal_profile"];
    if (personalProfileData && [personalProfileData class] != [NSNull class]) {
        PersonalProfile *profile = [PersonalProfile profileWithData:personalProfileData];
        [details setPersonalProfile:profile];
    }
    return details;
}

@end
