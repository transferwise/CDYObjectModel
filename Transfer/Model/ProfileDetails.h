//
//  ProfileDetails.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalProfile, BusinessProfile;

@interface ProfileDetails : NSObject

@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, strong) PersonalProfile *personalProfile;
@property (nonatomic, strong) BusinessProfile *businessProfile;
@property (nonatomic, copy, readonly) NSString *reference;

- (NSString *)displayName;

+ (ProfileDetails *)detailsWithData:(NSDictionary *)data;

@end
