//
//  BusinessProfileInput.m
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileInput.h"
#import "ProfileDetails.h"

@implementation BusinessProfileInput

- (NSDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"businessName"] = self.businessName;
    data[@"registrationNumber"] = self.registrationNumber;
    data[@"descriptionOfBusiness"] = self.descriptionOfBusiness;
    data[@"addressFirstLine"] = self.addressFirstLine;
    data[@"postCode"] = self.postCode;
    data[@"city"] = self.city;
    data[@"countryCode"] = self.countryCode;
    return [NSDictionary dictionaryWithDictionary:data];
}

@end
