//
//  PaymentValidation.h
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ObjectModel;

@protocol PaymentValidation <NSObject>

- (void)validatePayment:(NSManagedObjectID *)paymentInput;

- (void)setObjectModel:(ObjectModel *)objectModel;
- (void)setSuccessBlock:(TRWActionBlock)successBlock;
- (void)setErrorBlock:(TRWErrorBlock)errorBlock;

@end
