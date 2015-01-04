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
@property (copy, nonatomic)	PaymentValidationBlock validationBlock;

@end

@implementation PaymentValidator

- (void)validatePayment:(NSManagedObjectID *)paymentInput
{
	__weak typeof(self) weakSelf = self;
	
	TRWActionBlock paymentValidationBlock =  ^{
		MCLog(@"Validate payment");
		
		CreatePaymentOperation *operation = [CreatePaymentOperation validateOperationWithInput:paymentInput];
		
		[weakSelf setExecutedOperation:operation];
		[operation setObjectModel:weakSelf.objectModel];
		
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
	};
	
	if (self.validationBlock)
	{
		self.validationBlock(paymentValidationBlock);
	}
	else
	{
		paymentValidationBlock();
	}
}

@end
