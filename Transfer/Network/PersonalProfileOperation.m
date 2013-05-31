//
//  PersonalProfileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ProfileDetails.h"
#import "Credentials.h"
#import "PersonalProfile.h"
#import "PersonalProfileInput.h"

NSString *const kUpdatePersonalProfilePath = @"/user/updatePersonalProfile";
NSString *const kValidatePersonalProfilePath = @"/user/validatePersonalProfile";

@interface PersonalProfileOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) PersonalProfileInput *profile;

@end

@implementation PersonalProfileOperation

- (id)initWithPath:(NSString *)path profile:(PersonalProfileInput *)data {
    self = [super init];
    if (self) {
        _path = path;
        _profile = data;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:self.path];

    __block __weak PersonalProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        if (details.personalProfile) {
            [Credentials setDisplayName:[details displayName]];
        }
        weakSelf.saveResultHandler(details, nil);
    }];

    [self postData:[self.profile data] toPath:path];
}

+ (PersonalProfileOperation *)commitOperationWithProfile:(PersonalProfileInput *)profile {
    return [[PersonalProfileOperation alloc] initWithPath:kUpdatePersonalProfilePath profile:profile];
}

@end
