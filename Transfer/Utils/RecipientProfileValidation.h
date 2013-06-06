//
//  RecipientProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Recipient;
@class RecipientProfileInput;

typedef void (^RecipientProfileValidationBlock)(Recipient *recipient, NSError *error);

@protocol RecipientProfileValidation <NSObject>

- (void)validateRecipient:(RecipientProfileInput *)recipientProfile completion:(RecipientProfileValidationBlock)completion;

@end
