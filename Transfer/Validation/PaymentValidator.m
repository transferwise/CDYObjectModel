//
//  PaymentValidator.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PaymentValidator.h"
#import "CreatePaymentOperation.h"

@interface PaymentValidator ()

@property (copy, nonatomic) TRWErrorBlock errorBlock;

@end

@implementation PaymentValidator

- (void)validatePayment:(NSManagedObjectID *)paymentInput
{
	MCLog(@"Validate payment");
	
	CreatePaymentOperation *operation = [CreatePaymentOperation validateOperationWithInput:paymentInput];
	
	[self setExecutedOperation:operation];
	[operation setObjectModel:self.objectModel];
	
	__weak typeof(self) weakSelf = self;
	
	[operation setResponseHandler:^(NSManagedObjectID *paymentID, NSError *error) {
		if (error)
		{
			weakSelf.errorBlock(error);
			return;
		}
		
		MCLog(@"Payment valid");
		weakSelf.successBlock();
	}];
	
	[operation execute];
}

@end
