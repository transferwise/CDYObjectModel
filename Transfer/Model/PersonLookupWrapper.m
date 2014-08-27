//
//  PersonLookupWrapper.m
//  Transfer
//
//  Created by Juhan Hion on 25.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PersonLookupWrapper.h"

@interface PersonLookupWrapper()

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, assign) ABRecordID recordId;

@end

@implementation PersonLookupWrapper

-(instancetype)initWithRecordId:(ABRecordID)recordId
					  firstname:(NSString*)first
					   lastName:(NSString*)last
{
	if(!recordId)
	{
		return nil;
	}
	
	self = [super init];
	if(self)
	{
		_recordId = recordId;
		_firstName = first;
		_lastName = last;
	}
	return self;
}

-(instancetype)initWithManagedObjectId:(NSManagedObjectID*)objectId
							 firstname:(NSString*)first
							  lastName:(NSString*)last
{
	if(!objectId)
	{
		return nil;
	}
	
	self = [super init];
	if(self)
	{
		_managedObjectId = objectId;
		_firstName = first;
		_lastName = last;
	}
	
	return self;
}

-(NSString*)presentableString:(enum NameOrder)order
{
	switch (order) {
		case FirstNameFirst:
			return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName?:@""];
			break;
		case LastNameFirst:
		default:
			return [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName?:@""];
			break;
	}
}

-(NSString*)presentableString
{
	return [self presentableString:LastNameFirst];
}

@end

