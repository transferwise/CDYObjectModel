//
//  RecipientProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

typedef void (^RecipientProfileValidationBlock)(NSError *error);

@protocol RecipientProfileValidation <NSObject>

- (void)validateRecipient:(NSManagedObjectID *)recipientProfile completion:(RecipientProfileValidationBlock)completion;
- (void)setObjectModel:(ObjectModel *)objectModel;

@end
