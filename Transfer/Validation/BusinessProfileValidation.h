//
//  BusinessProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 6/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ObjectModel;

typedef void (^BusinessProfileValidationBlock)(NSError *error);

@protocol BusinessProfileValidation <NSObject>

- (void)validateBusinessProfile:(BusinessProfileValidationBlock)handler;

- (void)setObjectModel:(ObjectModel *)objectModel;

@optional
- (void)setSuccessBlock:(TRWActionBlock)successBlock;
- (void)setPersonalProfileNotFilledBlock:(TRWActionBlock)personalProfileNotFilledBlock;

@end
