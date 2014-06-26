//
//  NameLookupWrapper.h
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

NS_ENUM(NSUInteger, NameOrder)
{
    LastNameFirst =0,
    FirstNameFirst,
    NickNameFirst
};

@interface NameLookupWrapper : NSObject

@property (nonatomic, readonly) NSString* firstName;
@property (nonatomic, readonly) NSString* lastName;
@property (nonatomic, readonly) NSString* nickName;
@property (nonatomic, readonly) NSString* email;
@property (nonatomic, readonly) ABRecordID recordId;

-(instancetype)initWithId:(ABRecordID)recordId firstname:(NSString*)first lastName:(NSString*)last email:(NSString*)email nickName:(NSString*)nickName;

-(NSString*)presentableString:(enum NameOrder)order;
-(NSString*)presentableString;


@end
