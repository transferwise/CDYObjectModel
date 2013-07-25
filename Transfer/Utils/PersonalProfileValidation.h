//
//  PersonalProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainProfileDetails;
@class ObjectModel;

typedef void (^PersonalProfileValidationBlock)(PlainProfileDetails *details, NSError *error);

@protocol PersonalProfileValidation <NSObject>

- (void)validatePersonalProfile:(NSManagedObjectID *)profileID withHandler:(PersonalProfileValidationBlock)handler;
- (void)setObjectModel:(ObjectModel *)objectModel;

@end
