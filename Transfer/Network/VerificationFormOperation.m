//
//  VerificationFormOperation.m
//  Transfer
//
//  Created by Juhan Hion on 19.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "VerificationFormOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"

//TODO: this is probably going to change to just verificationform
NSString *const kVerificationFormPath = @"/ach/getverificationform";

@interface VerificationFormOperation ()

@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSNumber *paymentId;

@end

@implementation VerificationFormOperation

- (instancetype)initWithAccount:(NSString *)accountNumber
				  routingNumber:(NSString *)routingNumber
					  paymentId:(NSNumber *)paymentId
{
	self = [super init];
	if (self)
	{
		self.accountNumber = accountNumber;
		self.routingNumber = routingNumber;
		self.paymentId = paymentId;
	}
	return  self;
}

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kVerificationFormPath];
	
	__weak VerificationFormOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error, nil);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		if (response[@"referralLinks"])
		{
		}
		else
		{
			weakSelf.resultHandler(nil, nil);
		}
	}];
	
	[self getDataFromPath:path params:@{@"routingNumber" : self.routingNumber,
										@"accountNumber" : self.accountNumber,
										//TODO: this has been changed to paymentId, but is undeployed
										@"initialRequestId" : self.paymentId}];
	
}

+ (VerificationFormOperation *)verificationFormOperationWithAccount:(NSString *)accountNumber
													  routingNumber:(NSString *)routingNumber
														  paymentId:(NSNumber *)paymentId
{
	return [[VerificationFormOperation alloc] initWithAccount:accountNumber
												routingNumber:routingNumber
													paymentId:paymentId];
}

@end
