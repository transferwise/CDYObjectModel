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
#import "Mixpanel+Customisation.h"
#import "NSString+NullString.h"

@implementation ObjectModel (Users)

- (User *)userWithEmail:(NSString *)email
{
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    User *user = [self fetchEntityNamed:[User entityName]
						  withPredicate:emailPredicate];
    if (!user)
	{
        user = [User insertInManagedObjectContext:self.managedObjectContext];
        [user setEmail:email];
    }
    return user;
}

- (void)createOrUpdateUserWithData:(NSDictionary *)rawData
{
    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSString *email = data[@"email"];
    [Credentials setUserEmail:email];
    User *user = [self userWithEmail:email];
    [user setPReference:data[@"pReference"]];
    NSInteger mixpanelId = [user deducedId];
    [[Mixpanel sharedInstance] registerSuperProperties:@{@"distinct_id":@(mixpanelId)}];

    NSDictionary *personalProfileData = data[@"personalProfile"];
    if (personalProfileData)
	{
        [user setPersonalProfile:[self personalProfileWithData:personalProfileData
													   forUser:user]];
    }

    NSDictionary *businessProfileData = data[@"businessProfile"];
    if (businessProfileData)
	{
        [user setBusinessProfile:[self businessProfileWithData:businessProfileData
													   forUser:user]];
    }
}

- (PersonalProfile *)personalProfileWithData:(NSDictionary *)rawData
									 forUser:(User *)user
{
    if (!rawData)
	{
        return nil;
    }

    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", user];
    PersonalProfile *profile = [self fetchEntityNamed:[PersonalProfile entityName]
										withPredicate:userPredicate];
    if (!profile)
	{
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
    [profile setCountryCode:data[@"countryCode"]];
    [profile setState:data[@"state"]];
	[profile setOccupation:data[@"occupation"]];

    return profile;
}

- (BusinessProfile *)businessProfileWithData:(NSDictionary *)rawData
									 forUser:(User *)user
{
    if (!rawData)
	{
        return nil;
    }

    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", user];
    BusinessProfile *profile = [self fetchEntityNamed:[BusinessProfile entityName]
										withPredicate:userPredicate];
    if (!profile)
	{
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
    [profile setState:data[@"state"]];
	//api will return "null" as a string value, if these haven't been submitted
	[profile setCompanyRole:[data[@"companyRole"] getNullOnNullAsValue]];
	[profile setCompanyType:[data[@"companyType"] getNullOnNullAsValue]];

    return profile;
}

- (User *)currentUser
{
    if ([Credentials userLoggedIn])
	{
        return [self userWithEmail:[Credentials userEmail]];
    }

    return [self anonymousUser];
}

- (User *)anonymousUser
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"anonymous = YES"];
    User *user = [self fetchEntityNamed:[User entityName]
						  withPredicate:predicate];
    if (!user)
	{
        user = [User insertInManagedObjectContext:self.managedObjectContext];
        [user setAnonymousValue:YES];
    }

    return user;
}

- (void)saveReferralData:(NSDictionary*)data
{
    if (data)
    {
        User* user = [self currentUser];
        if(data[@"successfulReferrals"])
        {
            NSInteger count = [data[@"successfulReferrals"] count];
            
            if (count > 0)
            {
                if (user)
                {
                    user.successfulInviteCount = @(count);
                }
            }
        }
        NSNumber *amount = data[@"amount"];
        if(amount && [amount intValue] > 0)
        {
            user.invitationReward = amount;
        }
        NSString *currencyCode = data[@"currency"];
        if(currencyCode && [currencyCode length] > 0)
        {
            user.invitationRewardCurrency = currencyCode;
        }
    }
    
}

- (void)removeAnonymousUser
{
    User *anonymous = [self anonymousUser];
    if (anonymous)
	{
        [self deleteObject:anonymous saveAfter:NO];
    }
}

- (void)markAnonUserWithEmail:(NSString *)email
{
    User *user = [self anonymousUser];
    MCAssert(user);
    [user setEmail:email];
    [user setAnonymousValue:NO];
}

- (void)saveDeviceToken:(NSString *)deviceToken
{
	User* user = [self currentUser];
	
	user.deviceToken = deviceToken;
}

@end
