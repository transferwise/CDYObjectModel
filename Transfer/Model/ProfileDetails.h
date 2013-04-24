//
//  ProfileDetails.h
//  Transfer
//
//  Created by Jaanus Siim on 4/23/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PersonalProfile;

@interface ProfileDetails : NSObject

@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, strong) PersonalProfile *personalProfile;

- (NSString *)displayName;

+ (ProfileDetails *)detailsWithData:(NSDictionary *)data;

@end
