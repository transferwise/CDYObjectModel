//
//  PersonalProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainProfileDetails;
@class PlainPersonalProfileInput;

typedef void (^PersonalProfileValidationBlock)(PlainProfileDetails *details, NSError *error);

@protocol PersonalProfileValidation <NSObject>

- (void)validatePersonalProfile:(PlainPersonalProfileInput *)profile withHandler:(PersonalProfileValidationBlock)handler;

@end
