//
//  Country.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "Country.h"

@interface Country ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isoCode2;
@property (nonatomic, copy) NSString *isoCode3;

@end

@implementation Country

+ (Country *)countryWithData:(NSDictionary *)data {
    Country *country = [[Country alloc] init];
    //TODO jaanus: take country name from locale?
    [country setName:data[@"name"]];
    [country setIsoCode2:data[@"iso2_code"]];
    [country setIsoCode3:data[@"iso3_code"]];
    return country;
}

@end
