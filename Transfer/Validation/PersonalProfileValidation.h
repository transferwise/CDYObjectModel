//
//  PersonalProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ObjectModel;
@class NSManagedObjectID;

typedef void (^PersonalProfileValidationBlock)(NSError *error);

@protocol PersonalProfileValidation <NSObject>

- (void)validatePersonalProfile:(NSManagedObjectID *)profileID
					withHandler:(PersonalProfileValidationBlock)handler;

- (void)setObjectModel:(ObjectModel *)objectModel;
- (void)setSuccessBlock:(TRWActionBlock)successBlock;

@end
