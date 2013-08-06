//
//  PersonalProfileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/7/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "JCSObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "Constants.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"

NSString *const kUpdatePersonalProfilePath = @"/user/updatePersonalProfile";
NSString *const kValidatePersonalProfilePath = @"/user/validatePersonalProfile";

@interface PersonalProfileOperation ()

@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSManagedObjectID *profile;

@end

@implementation PersonalProfileOperation

- (id)initWithPath:(NSString *)path profile:(NSManagedObjectID *)data {
    self = [super init];
    if (self) {
        _path = path;
        _profile = data;
    }
    return self;
}

- (void)execute {
    MCAssert(self.objectModel);
    NSString *path = [self addTokenToPath:self.path];

    __block __weak PersonalProfileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.saveResultHandler(error);
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            if ([response[@"status"] isEqualToString:@"valid"]) {
                MCLog(@"Valid. Continue");
            } else {
                MCLog(@"Update user data");
                [weakSelf.workModel createOrUpdateUserWithData:response];
            }

            [weakSelf.workModel saveContext:^{
                weakSelf.saveResultHandler(nil);
            }];
        }];
    }];

    [self.workModel performBlock:^{
        PersonalProfile *personalProfile = (PersonalProfile *) [weakSelf.workModel.managedObjectContext objectWithID:self.profile];
        MCAssert(personalProfile);

        [self postData:[personalProfile data] toPath:path];
    }];
}

+ (PersonalProfileOperation *)commitOperationWithProfile:(NSManagedObjectID *)profile {
    return [[PersonalProfileOperation alloc] initWithPath:kUpdatePersonalProfilePath profile:profile];
}

+ (PersonalProfileOperation *)validateOperationWithProfile:(NSManagedObjectID *)profile {
    return [[PersonalProfileOperation alloc] initWithPath:kValidatePersonalProfilePath profile:profile];
}

@end
