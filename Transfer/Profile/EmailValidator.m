//
//  EmailValidator.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "EmailValidator.h"
#import "Constants.h"
#import "EmailCheckOperation.h"
#import "TransferwiseOperation.h"

@interface EmailValidator ()

@property (strong, nonatomic) TransferwiseOperation *executedOperation;

@end

@implementation EmailValidator

- (void)verifyEmail:(NSString *)email
	withResultBlock:(EmailValidationResultBlock)resultBlock
{
	MCLog(@"Verify email %@ available", email);
	EmailCheckOperation *operation = [EmailCheckOperation operationWithEmail:email];
	[self setExecutedOperation:operation];
	[operation setResultHandler:resultBlock];
	
	[operation execute];
}

@end
