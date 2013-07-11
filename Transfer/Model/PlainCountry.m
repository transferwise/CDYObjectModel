//
//  PlainCountry.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PlainCountry.h"

@interface PlainCountry ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isoCode2;
@property (nonatomic, copy) NSString *isoCode3;

@end

@implementation PlainCountry

+ (PlainCountry *)countryWithData:(NSDictionary *)data {
    PlainCountry *country = [[PlainCountry alloc] init];
    //TODO jaanus: take country name from locale?
    [country setName:data[@"name"]];
    [country setIsoCode2:data[@"iso2Code"]];
    [country setIsoCode3:data[@"iso3Code"]];
    return country;
}

@end
