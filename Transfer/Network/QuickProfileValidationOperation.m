//
//  QuickProfileValidationOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 8/5/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "QuickProfileValidationOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NSMutableDictionary+SaneData.h"

@interface QuickProfileValidationOperation ()

@property (nonatomic, copy) NSString *validationPath;
@property (nonatomic, strong) NSMutableDictionary *data;

@end

@implementation QuickProfileValidationOperation

- (id)initWithValidationPath:(NSString *)path {
    self = [super init];
    if (self) {
        _validationPath = path;
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)execute {
    __block __weak QuickProfileValidationOperation *weakSelf = self;
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        weakSelf.validationHandler(@[]);
    }];

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.validationHandler(@[]);
    }];

    [self postData:self.data toPath:[self addTokenToPath:self.validationPath]];
}

- (void)handleErrorResponseData:(NSDictionary *)errorData {
    self.validationHandler(errorData[@"errors"]);
}

+ (QuickProfileValidationOperation *)personalProfileValidation {
    return [[QuickProfileValidationOperation alloc] initWithValidationPath:@"/user/validatePersonalProfile"];
}

+ (QuickProfileValidationOperation *)businessProfileValidation {
    return [[QuickProfileValidationOperation alloc] initWithValidationPath:@"/user/validateBusinessProfile"];
}

- (void)setFirstName:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"firstName"];
}

- (void)setLastName:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"lastName"];
}

- (void)setPhoneNumber:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"phoneNumber"];
}

- (void)setAddressFirstLine:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"addressFirstLine"];
}

- (void)setPostCode:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"postCode"];
}

- (void)setCity:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"city"];
}

- (void)setCountryCode:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"countryCode"];
}

- (void)setDateOfBirth:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"dateOfBirth"];
}

- (void)setName:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"businessName"];
}

- (void)setRegistrationNumber:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"registrationNumber"];
}

- (void)setBusinessDescription:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"descriptionOfBusiness"];
}

- (void)setState:(NSString *)value {
    [self.data setNotNilValue:value forKey:@"state"];
}

@end
