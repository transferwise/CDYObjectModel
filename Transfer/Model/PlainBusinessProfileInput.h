//
//  PlainBusinessProfileInput.h
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlainBusinessProfileInput : NSObject

@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *registrationNumber;
@property (nonatomic, copy) NSString *descriptionOfBusiness;
@property (nonatomic, copy) NSString *addressFirstLine;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *countryCode;

- (NSDictionary *)data;

@end
