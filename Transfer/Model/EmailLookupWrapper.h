//
//  NameLookupWrapper.h
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonLookupWrapper.h"

@interface EmailLookupWrapper : PersonLookupWrapper

@property (nonatomic, readonly) NSString* email;

-(instancetype)initWithRecordId:(ABRecordID)recordId firstname:(NSString*)first lastName:(NSString*)last email:(NSString*)email;
-(instancetype)initWithManagedObjectId:(NSManagedObjectID*)objectId firstname:(NSString*)first lastName:(NSString*)last email:(NSString*)email;

@end
