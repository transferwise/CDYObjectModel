//
//  ObjectModel+Users.m
//  Transfer
//
//  Created by Jaanus Siim on 7/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Users.h"
#import "User.h"
#import "NSDictionary+Cleanup.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"
#import "Credentials.h"
#import "Currency.h"
#import "Recipient.h"
#import "Constants.h"

@implementation ObjectModel (Users)

- (User *)userWithEmail:(NSString *)email {
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    User *user = [self fetchEntityNamed:[User entityName] withPredicate:emailPredicate];
    if (!user) {
        user = [User insertInManagedObjectContext:self.managedObjectContext];
        [user setEmail:email];
    }
    return user;
}

- (void)createOrUpdateUserWithData:(NSDictionary *)rawData {
    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSString *email = data[@"email"];
    [Credentials setUserEmail:email];
    User *user = [self userWithEmail:email];
    [user setPReference:data[@"pReference"]];
    [user setPersonalProfile:[self personalProfileWithData:data[@"personalProfile"] forUser:user]];
    [user setBusinessProfile:[self businessProfileWithData:data[@"businessProfile"] forUser:user]];
}

- (PersonalProfile *)personalProfileWithData:(NSDictionary *)data forUser:(User *)user {
    if (!data) {
        return nil;
    }

    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", user];
    PersonalProfile *profile = [self fetchEntityNamed:[PersonalProfile entityName] withPredicate:userPredicate];
    if (!profile) {
        profile = [PersonalProfile insertInManagedObjectContext:self.managedObjectContext];
    }

    [profile setFirstName:data[@"firstName"]];
    [profile setLastName:data[@"lastName"]];
    [profile setDateOfBirth:data[@"dateOfBirth"]];
    [profile setPhoneNumber:data[@"phoneNumber"]];
    [profile setAddressFirstLine:data[@"addressFirstLine"]];
    [profile setPostCode:data[@"postCode"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"countryCode"]];
    [profile setReadonlyFields:[data[@"readonlyFields"] componentsJoinedByString:@"|"]];

    return profile;
}

- (BusinessProfile *)businessProfileWithData:(NSDictionary *)data forUser:(User *)user {
    if (!data) {
        return nil;
    }

    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", user];
    BusinessProfile *profile = [self fetchEntityNamed:[BusinessProfile entityName] withPredicate:userPredicate];
    if (!profile) {
        profile = [BusinessProfile insertInManagedObjectContext:self.managedObjectContext];
    }

    [profile setName:data[@"name"]];
    [profile setRegistrationNumber:data[@"registrationNumber"]];
    [profile setBusinessDescription:data[@"description"]];
    [profile setAddressFirstLine:data[@"addressFirstLine"]];
    [profile setPostCode:data[@"postCode"]];
    [profile setCity:data[@"city"]];
    [profile setCountryCode:data[@"countryCode"]];
    [profile setReadonlyFields:[data[@"readonlyFields"] componentsJoinedByString:@"|"]];

    return profile;
}

- (User *)currentUser {
    if ([Credentials userLoggedIn]) {
        return [self userWithEmail:[Credentials userEmail]];
    }

    return [self anonymousUser];
}

- (User *)anonymousUser {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anonymous = YES"];
    User *user = [self fetchEntityNamed:[User entityName] withPredicate:predicate];
    if (!user) {
        user = [User insertInManagedObjectContext:self.managedObjectContext];
        [user setAnonymousValue:YES];
    }

    return user;
}

- (void)removeAnonymousUser {
    User *anonymous = [self anonymousUser];
    if (anonymous) {
        [self deleteObject:anonymous saveAfter:NO];
    }
}

- (void)markAnonUserWithEmail:(NSString *)email {
    User *user = [self anonymousUser];
    MCAssert(user);
    [user setEmail:email];
    [user setAnonymousValue:NO];
}

@end
