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

@end

@implementation PhoneBookProfile {
    ABRecordRef _record;
}

- (id)initWithRecord:(ABRecordRef)person {
    self = [super init];
    if (self) {
        _record = CFRetain(person);
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
    self.address = [[self allAddressObjects] lastObject];

}

- (NSArray *)allAddressObjects {
    NSArray *addresses = [self arrayForProperty:kABPersonAddressProperty];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[addresses count]];
    NSLog(@">>> %@", [addresses lastObject]);
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
