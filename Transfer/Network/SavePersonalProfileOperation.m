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

NSString *const kUpdatePersonalProfilePath = @"/user/updatePersonalProfile";
NSString *const kValidatePersonalProfilePath = @"/user/validatePersonalProfile";

@interface SavePersonalProfileOperation ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation SavePersonalProfileOperation

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _data = data;
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

    [self postData:self.data toPath:path];
}

+ (SavePersonalProfileOperation *)operationWithData:(NSDictionary *)data {
    return [[SavePersonalProfileOperation alloc] initWithData:data];
}

@end
