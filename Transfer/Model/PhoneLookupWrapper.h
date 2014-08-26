//
//  PhoneLookupWrapper.h
//  Transfer
//
//  Created by Juhan Hion on 25.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PersonLookupWrapper.h"

@interface PhoneLookupWrapper : PersonLookupWrapper

@property (nonatomic, readonly) NSArray* phones;

- (instancetype)initWithRecordId:(ABRecordID)recordId
					   firstname:(NSString *)first
						lastName:(NSString *)last
						  phones:(NSArray *)phones;
- (instancetype)initWithManagedObjectId:(NSManagedObjectID *)objectId
							  firstname:(NSString *)first
							   lastName:(NSString *)last
								 phones:(NSArray *)phones;

- (BOOL)hasMatchingPhones:(NSString *)sourcePhone;

@end
