//
//  PersonalProfileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "PlainProfileDetails.h"
#import "Credentials.h"
#import "PlainPersonalProfile.h"
#import "PlainPersonalProfileInput.h"

NSString *const kUpdatePersonalProfilePath = @"/user/updatePersonalProfile";
NSString *const kValidatePersonalProfilePath = @"/user/validatePersonalProfile";

@interface PersonalProfileOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) PlainPersonalProfileInput *profile;

@end

@implementation PersonalProfileOperation

- (id)initWithPath:(NSString *)path profile:(PlainPersonalProfileInput *)data {
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
        PlainProfileDetails *details = [PlainProfileDetails detailsWithData:response];
        if (details.personalProfile) {
            [Credentials setDisplayName:[details displayName]];
        }
        weakSelf.saveResultHandler(details, nil);
    }];

    [self postData:[self.profile data] toPath:path];
}

+ (PersonalProfileOperation *)commitOperationWithProfile:(PlainPersonalProfileInput *)profile {
    return [[PersonalProfileOperation alloc] initWithPath:kUpdatePersonalProfilePath profile:profile];
}

+ (PersonalProfileOperation *)validateOperationWithProfile:(PlainPersonalProfileInput *)profile {
    return [[PersonalProfileOperation alloc] initWithPath:kValidatePersonalProfilePath profile:profile];
}

@end
