//
//  RecipientProfileValidator.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RecipientProfileValidator.h"
#import "RecipientOperation.h"

@implementation RecipientProfileValidator

- (void)validateRecipient:(NSManagedObjectID *)recipientProfile
			   completion:(RecipientProfileValidationBlock)completion
{
	MCLog(@"Validate recipient");
	RecipientOperation *operation = [RecipientOperation validateOperationWithRecipient:recipientProfile];
	[self setExecutedOperation:operation];
	[operation setObjectModel:self.objectModel];
	
	[operation setResponseHandler:completion];
	
	[operation execute];
}

@end
