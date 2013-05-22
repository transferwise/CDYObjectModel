//
//  PhoneBookAddress.m
//  Transfer
//
//  Created by Jaanus Siim on 5/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PhoneBookAddress.h"

@interface PhoneBookAddress ()

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *zipCode;

@end

@implementation PhoneBookAddress

+ (PhoneBookAddress *)addressWithData:(NSDictionary *)data {
    PhoneBookAddress *address = [[PhoneBookAddress alloc] init];

    address.city = data[@"City"];
    address.country = data[@"Country"];
    address.countryCode = data[@"CountryCode"];
    address.state = data[@"State"];
    address.street = data[@"Street"];
    address.zipCode = data[@"ZIP"];

    return address;
}

@end
