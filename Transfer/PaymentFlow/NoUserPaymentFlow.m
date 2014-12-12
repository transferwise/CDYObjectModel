//
//  NoUserPaymentFlow.m
//  Transfer
//
//  Created by Jaanus Siim on 6/4/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "NoUserPaymentFlow.h"
#import "Credentials.h"

@implementation NoUserPaymentFlow


-(void)commitPaymentWithSuccessBlock:(TRWActionBlock)successBlock
						errorHandler:(TRWErrorBlock)errorHandler
{
	MCLog(@"Commit payment");
	[self setPaymentErrorHandler:errorHandler];
	[self setVerificationSuccessBlock:successBlock];
	
	//awesome how a no user flow can become a user flow in the middle
	if ([Credentials userLoggedIn])
	{
		[self handleNextStepOfPendingPaymentCommit];
	}
	else
	{
		[self registerUser];
	}
}

@end
