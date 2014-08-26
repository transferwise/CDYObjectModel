//
//  PersonLookupWrapper.h
//  Transfer
//
//  Created by Juhan Hion on 25.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

NS_ENUM(NSUInteger, NameOrder)
{
	LastNameFirst =0,
	FirstNameFirst
};

@interface PersonLookupWrapper : NSObject

@property (nonatomic, readonly) NSString* firstName;
@property (nonatomic, readonly) NSString* lastName;
@property (nonatomic, readonly) ABRecordID recordId;
@property (nonatomic, readonly) NSManagedObjectID *managedObjectId;

-(instancetype)initWithRecordId:(ABRecordID)recordId firstname:(NSString*)first lastName:(NSString*)last;
-(instancetype)initWithManagedObjectId:(NSManagedObjectID*)objectId firstname:(NSString*)first lastName:(NSString*)last;

-(NSString*)presentableString:(enum NameOrder)order;
-(NSString*)presentableString;

@end
