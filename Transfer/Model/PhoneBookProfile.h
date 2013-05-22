//
//  PhoneBookProfile.h
//  Transfer
//
//  Created by Jaanus Siim on 5/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class PhoneBookAddress;

@interface PhoneBookProfile : NSObject

@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSDate *dateOfBirth;
@property (nonatomic, strong, readonly) PhoneBookAddress *address;
@property (nonatomic, copy, readonly) NSString *organisation;

- (id)initWithRecord:(ABRecordRef)person;
- (id)initWithRecord:(ABRecordRef)person selectedAddressIdentifier:(ABMultiValueIdentifier)identifier;

- (void)loadData;
- (NSUInteger)addressesCount;

@end
