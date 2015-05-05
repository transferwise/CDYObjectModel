//
//  ObjectModel+Users.h
//  Transfer
//
//  Created by Jaanus Siim on 7/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class User;
@class Currency;

typedef NS_ENUM(int, AdditionalAttributeType)
{
	CompanyRole,
	CompanyType
};

@interface ObjectModel (Users)

- (void)createOrUpdateUserWithData:(NSDictionary *)data;
- (User *)currentUser;
- (void)removeAnonymousUser;
- (void)markAnonUserWithEmail:(NSString *)email;
- (void)saveReferralData:(NSDictionary*)data;
- (void)saveDeviceToken:(NSString *)deviceToken;
- (void)saveAdditionalAttributeWithType:(AdditionalAttributeType)type
									key:(NSString *)key
								  value:(NSString *)value;
- (NSDictionary *)additionalAttributesForType:(AdditionalAttributeType)type;
- (NSFetchedResultsController *)fetchedControllerForAttributesOfType:(AdditionalAttributeType)type;

@end
