//
//  BusinessProfileValidator.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileValidator.h"
#import "BusinessProfileOperation.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "User.h"
#import "ObjectModel+Users.h"

@interface BusinessProfileValidator()

@property (copy, nonatomic) TRWActionBlock personalProfileNotFilledBlock;

@end

@implementation BusinessProfileValidator

- (void)validateBusinessProfile:(NSManagedObjectID *)profile
					withHandler:(BusinessProfileValidationBlock)handler
{
	MCLog(@"validateBusinessProfile");
	BusinessProfileOperation *operation = [BusinessProfileOperation validateWithData:profile];
	[self setExecutedOperation:operation];
	[operation setObjectModel:self.objectModel];
	__weak typeof(self) weakSelf = self;
	[operation setSaveResultHandler:^(NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (error)
			{
				handler(error);
				return;
			}
			
			handler(nil);
			
			PendingPayment *payment = [weakSelf.objectModel pendingPayment];
			[payment setProfileUsed:@"business"];
			[self.objectModel saveContext];
			
			if ([weakSelf personalProfileFilled])
			{
				weakSelf.successBlock();
			}
			else
			{
				weakSelf.personalProfileNotFilledBlock();
			}
		});
	}];
	
	[operation execute];
}

- (BOOL)personalProfileFilled
{
	return [self.objectModel.currentUser personalProfileFilled];
}

#pragma mark - payment flow progress indiation
-(float)paymentFlowProgress
{
    return 0.7f;
}

@end
