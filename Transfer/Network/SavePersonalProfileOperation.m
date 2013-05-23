//
//  SavePersonalProfileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SavePersonalProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ProfileDetails.h"
#import "Credentials.h"
#import "PersonalProfile.h"

NSString *const kUpdatePersonalProfilePath = @"/user/updatePersonalProfile";
NSString *const kValidatePersonalProfilePath = @"/user/validatePersonalProfile";

@interface SavePersonalProfileOperation ()

@property (nonatomic, strong) PersonalProfile *profile;

@end

@implementation SavePersonalProfileOperation

- (id)initWithProfile:(PersonalProfile *)data {
    self = [super init];
    if (self) {
        _profile = data;
    }
    return self;
}

- (void)execute {
    NSString *path;
    if ([Credentials userLoggedIn]) {
        path = [self addTokenToPath:kUpdatePersonalProfilePath];
    } else {
        path = [self addTokenToPath:kValidatePersonalProfilePath];
    }

    __block __weak SavePersonalProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(nil, error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        ProfileDetails *details = [ProfileDetails detailsWithData:response];
        [Credentials setDisplayName:[details displayName]];
        weakSelf.saveResultHandler(details, nil);
    }];

    [self postData:[self.profile data] toPath:path];
}

+ (SavePersonalProfileOperation *)operationWithProfile:(PersonalProfile *)profile {
    return [[SavePersonalProfileOperation alloc] initWithProfile:profile];
}

@end
