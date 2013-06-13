//
//  BusinessProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BusinessProfileInput;
@class ProfileDetails;

typedef void (^BusinessProfileValidationBlock)(ProfileDetails *details, NSError *error);

@protocol BusinessProfileValidation <NSObject>

- (void)validateProfile:(BusinessProfileInput *)profile withHandler:(BusinessProfileValidationBlock)handler;

@end
