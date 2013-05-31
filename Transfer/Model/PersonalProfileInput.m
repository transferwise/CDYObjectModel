//
//  PersonalProfileInput.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileInput.h"

@implementation PersonalProfileInput

- (NSDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"firstName"] = self.firstName;
    data[@"lastName"] = self.lastName;
    data[@"dateOfBirth"] = self.dateOfBirthString;
    data[@"phoneNumber"] = self.phoneNumber;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    return [NSDictionary dictionaryWithDictionary:data];
}

@end
