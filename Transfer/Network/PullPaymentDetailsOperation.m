//
//  PullPaymentDetailsOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 9/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PullPaymentDetailsOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+PendingPayments.h"
#import "ObjectModel+Payments.h"

NSString *const kPaymentDetailsPath = @"/payment/details";

@interface PullPaymentDetailsOperation ()

@property(nonatomic, strong) NSNumber *paymentId;

@end

@implementation PullPaymentDetailsOperation

- (id)initWithPaymentId:(NSNumber *)paymentId {
	self = [super init];
	if (self) {
		self.paymentId = paymentId;
	}
	return self;
}

- (void)execute {
	MCLog(@"Execute");
	NSString *path = [self addTokenToPath:kPaymentDetailsPath];

	__weak PullPaymentDetailsOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error);
	}];

	[self setOperationSuccessHandler:^(NSDictionary *response) {
		[weakSelf.workModel performBlock:^{
			[weakSelf.workModel createOrUpdatePaymentWithData:response];
			[weakSelf.workModel saveContext:^{
				weakSelf.resultHandler(nil);
			}];
		}];
	}];

	[self getDataFromPath:path params:@{@"paymentId" : self.paymentId}];
}


+ (PullPaymentDetailsOperation *)operationWithPaymentId:(NSNumber *)paymentId {
	return [[PullPaymentDetailsOperation alloc] initWithPaymentId:paymentId];
}

@end
