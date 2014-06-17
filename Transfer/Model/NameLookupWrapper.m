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
@property (nonatomic, assign) ABRecordID recordId;

@end

@implementation NameLookupWrapper

-(instancetype)initWithId:(ABRecordID)recordId firstname:(NSString*)first lastName:(NSString*)last nickName:(NSString*)nickName
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
        _nickName = nickName;
    }
    
    return self;
}

-(NSString*)presentableString:(enum NameOrder)order
{
    switch (order) {
        case NickNamefirst:
            return [NSString stringWithFormat:@"\"%@\", %@ %@", self.nickName, self.firstName, self.lastName];
            break;
        case FirstNameFirst:
            if (self.nickName)
            {
                return [NSString stringWithFormat:@"%@ \"%@\" %@", self.firstName, self.nickName, self.lastName];
            }
            else
            {
                return [NSString stringWithFormat:@"%@, %@", self.firstName, self.lastName];
            }
            break;
        case LastNameFirst:
        default:
            if (self.nickName)
            {
                return [NSString stringWithFormat:@"%@, %@ \"%@\"", self.lastName, self.firstName, self.nickName];
            }
            else
            {
                return [NSString stringWithFormat:@"%@, %@", self.firstName, self.lastName];
            }

            break;
    }
}

-(NSString*)presentableString
{
    return [self presentableString:LastNameFirst];
}

@end
