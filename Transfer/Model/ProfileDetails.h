//
//  ProfileDetails.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalProfile;
@class BusinessProfile;
@class PersonalProfileInput;

@interface ProfileDetails : NSObject

@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) PersonalProfile *personalProfile;
@property (nonatomic, strong) BusinessProfile *businessProfile;
@property (nonatomic, copy, readonly) NSString *reference;

- (NSString *)displayName;
- (PersonalProfileInput *)profileInput;

+ (ProfileDetails *)detailsWithData:(NSDictionary *)data;

@end
