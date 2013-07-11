//
//  PlainProfileDetails.m
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainProfileDetails.h"
#import "PlainPersonalProfile.h"
#import "PlainBusinessProfile.h"
#import "PlainPersonalProfileInput.h"

@interface PlainProfileDetails ()

@property (nonatomic, copy) NSString *reference;

@end

@implementation PlainProfileDetails

- (NSString *)displayName {
    return self.personalProfile ? [self.personalProfile fullName] : self.email;
}

+ (PlainProfileDetails *)detailsWithData:(NSDictionary *)data {
    PlainProfileDetails *details = [[PlainProfileDetails alloc] init];
    [details setEmail:data[@"email"]];
    [details setReference:data[@"pReference"]];
    NSDictionary *personalProfileData = data[@"personalProfile"];
    if (personalProfileData && [personalProfileData class] != [NSNull class]) {
        PlainPersonalProfile *profile = [PlainPersonalProfile profileWithData:personalProfileData];
        [details setPersonalProfile:profile];
    }
    NSDictionary *businessProfileData = data[@"businessProfile"];
    if (businessProfileData && [businessProfileData class] != [NSNull class]) {
        PlainBusinessProfile *profile = [PlainBusinessProfile profileWithData:businessProfileData];
        [details setBusinessProfile:profile];
    }
    return details;
}

- (PlainPersonalProfileInput *)profileInput {
    PlainPersonalProfileInput *input = [self.personalProfile input];

    if (!input) {
        input = [[PlainPersonalProfileInput alloc] init];
    }

    [input setEmail:self.email];
    return input;
}

@end
