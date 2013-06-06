//
//  PersonalProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileDetails;
@class PersonalProfileInput;

typedef void (^PersonalProfileValidationBlock)(ProfileDetails *details, NSError *error);

@protocol PersonalProfileValidation <NSObject>

- (void)validateProfile:(PersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler;

@end
