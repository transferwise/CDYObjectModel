//
//  QuickProfileValidationOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 8/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^QuickValidationBlock)(NSArray *issues);

@interface QuickProfileValidationOperation : TransferwiseOperation

@property (nonatomic, copy) QuickValidationBlock validationHandler;

+ (QuickProfileValidationOperation *)personalProfileValidation;
+ (QuickProfileValidationOperation *)businessProfileValidation;

- (void)setFirstName:(NSString *)value;
- (void)setLastName:(NSString *)value;
- (void)setPhoneNumber:(NSString *)value;
- (void)setAddressFirstLine:(NSString *)value;
- (void)setPostCode:(NSString *)value;
- (void)setCity:(NSString *)value;
- (void)setCountryCode:(NSString *)value;
- (void)setDateOfBirth:(NSString *)value;
- (void)setName:(NSString *)value;
- (void)setRegistrationNumber:(NSString *)value;
- (void)setBusinessDescription:(NSString *)value;

@end
