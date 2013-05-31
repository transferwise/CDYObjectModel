//
//  PersonalProfileInput.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalProfileInput : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *addressFirstLine;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *dateOfBirthString;
@property (nonatomic, assign) BOOL changed;

- (NSDictionary *)data;

@end
