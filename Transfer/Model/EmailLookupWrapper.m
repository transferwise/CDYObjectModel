//
//  NameLookupWrapper.m
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "EmailLookupWrapper.h"

@interface EmailLookupWrapper()

@property (nonatomic, strong) NSString* email;

@end

@implementation EmailLookupWrapper

-(instancetype)initWithRecordId:(ABRecordID)recordId
					  firstname:(NSString*)first
					   lastName:(NSString*)last
						  email:(NSString*)email
{
    self = [super initWithRecordId:recordId
						 firstname:first
						  lastName:last];
    if(self)
    {
        _email = email;
    }
    
    return self;
}

-(instancetype)initWithManagedObjectId:(NSManagedObjectID*)objectId
							 firstname:(NSString*)first
							  lastName:(NSString*)last
								 email:(NSString*)email
{
    self = [super initWithManagedObjectId:objectId
								firstname:first
								 lastName:last];
    if(self)
    {
        _email = email;
    }
    
    return self;
}

@end
