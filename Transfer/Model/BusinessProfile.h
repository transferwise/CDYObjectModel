//
//  BusinessProfile.h
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusinessProfileInput;

@interface BusinessProfile : NSObject

@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *registrationNumber;
@property (nonatomic, copy) NSString *descriptionOfBusiness;
@property (nonatomic, copy) NSString *addressFirstLine;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *countryCode;

+ (BusinessProfile *)profileWithData:(NSDictionary *)data;

- (BOOL)businessVerifiedValue;
- (BusinessProfileInput *)input;

@end
