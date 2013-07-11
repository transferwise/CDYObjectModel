//
//  RecipientProfileValidation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlainRecipient;
@class PlainRecipientProfileInput;

typedef void (^RecipientProfileValidationBlock)(PlainRecipient *recipient, NSError *error);

@protocol RecipientProfileValidation <NSObject>

- (void)validateRecipient:(PlainRecipientProfileInput *)recipientProfile completion:(RecipientProfileValidationBlock)completion;

@end
