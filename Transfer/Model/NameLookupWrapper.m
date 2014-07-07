//
//  NameLookupWrapper.m
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NameLookupWrapper.h"

@interface NameLookupWrapper()

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, assign) ABRecordID recordId;

@end

@implementation NameLookupWrapper

-(instancetype)initWithRecordId:(ABRecordID)recordId firstname:(NSString*)first lastName:(NSString*)last email:(NSString*)email
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
        _email = email;
    }
    
    return self;
}

-(instancetype)initWithManagedObjectId:(NSManagedObjectID*)objectId firstname:(NSString*)first lastName:(NSString*)last email:(NSString*)email
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
        _email = email;
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
