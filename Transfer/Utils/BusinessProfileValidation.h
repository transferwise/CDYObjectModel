//
//  BusinessProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainBusinessProfileInput;
@class PlainProfileDetails;

typedef void (^BusinessProfileValidationBlock)(PlainProfileDetails *details, NSError *error);

@protocol BusinessProfileValidation <NSObject>

- (void)validateBusinessProfile:(PlainBusinessProfileInput *)profile withHandler:(BusinessProfileValidationBlock)handler;

@end
