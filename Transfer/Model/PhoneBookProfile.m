//
//  PhoneBookProfile.m
//  Transfer
//
//  Created by Jaanus Siim on 5/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "PhoneBookProfile.h"
#import "Constants.h"
#import "PhoneBookAddress.h"

@interface PhoneBookProfile ()

@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, strong) NSDate *dateOfBirth;
@property (nonatomic, strong) PhoneBookAddress *address;
@property (nonatomic, copy) NSString *organisation;
@property (nonatomic, assign) ABMultiValueIdentifier selectedAddressIdentifier;

@end

@implementation PhoneBookProfile {
    ABRecordRef _record;
}

- (id)initWithRecordId:(ABRecordID)recordId {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordId);
    return [self initWithRecord:person selectedAddressIdentifier:kABMultiValueInvalidIdentifier];
}

- (id)initWithRecord:(ABRecordRef)person {
    return [self initWithRecord:person selectedAddressIdentifier:kABMultiValueInvalidIdentifier];
}

- (id)initWithRecord:(ABRecordRef)person selectedAddressIdentifier:(ABMultiValueIdentifier)identifier {
    self = [super init];
    if (self) {
        _record = CFRetain(person);
        _selectedAddressIdentifier = identifier;
    }
    return self;
}

- (void)dealloc {
    if (_record) {
        CFRelease(_record);
    }
}

- (void)loadData {
    MCLog(@"Load profile data");
    self.fullName = (__bridge_transfer NSString *) ABRecordCopyCompositeName(_record);
    self.firstName = [self getRecordString:kABPersonFirstNameProperty];
    self.lastName = [self getRecordString:kABPersonLastNameProperty];
    self.email = [[self arrayForProperty:kABPersonEmailProperty] lastObject];
    self.phone = [[self arrayForProperty:kABPersonPhoneProperty] lastObject];
    self.dateOfBirth = [self getRecordDate:kABPersonBirthdayProperty];
    if (self.selectedAddressIdentifier == kABMultiValueInvalidIdentifier) {
        self.address = [[self allAddressObjects] lastObject];
    } else {
        self.address = [self addressWithIdentifier:self.selectedAddressIdentifier];
    }
    self.organisation = [self getRecordString:kABPersonOrganizationProperty];

}

- (PhoneBookAddress *)addressWithIdentifier:(ABMultiValueIdentifier)identifier {
    CFTypeRef theProperty = ABRecordCopyValue(_record, kABPersonAddressProperty);
    NSDictionary *items = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(theProperty, self.selectedAddressIdentifier);
    CFRelease(theProperty);
    return [PhoneBookAddress addressWithData:items];
}

- (NSUInteger)addressesCount {
    return [[self arrayForProperty:kABPersonAddressProperty] count];
}


- (NSArray *)allAddressObjects {
    NSArray *addresses = [self arrayForProperty:kABPersonAddressProperty];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[addresses count]];
    for (NSDictionary *data in addresses) {
        PhoneBookAddress *address = [PhoneBookAddress addressWithData:data];
        [result addObject:address];
    }
    return [NSArray arrayWithArray:result];
}

- (NSDate *)getRecordDate:(ABPropertyID)anID {
    return (__bridge_transfer NSDate *) ABRecordCopyValue(_record, anID);
}

- (NSString *)getRecordString:(ABPropertyID)anID {
    return (__bridge_transfer NSString *) ABRecordCopyValue(_record, anID);
}

- (NSArray *)arrayForProperty:(ABPropertyID)anID {
    CFTypeRef theProperty = ABRecordCopyValue(_record, anID);
    NSArray *items = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(theProperty);
    CFRelease(theProperty);
    return items;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"%@ %@", self.firstName, self.lastName];
    [description appendString:@">"];
    return description;
}

@end
