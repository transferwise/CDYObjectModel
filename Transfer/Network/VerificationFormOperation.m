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
#import "TypeFieldParser.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "ObjectModel+AchBank.h"

NSString *const kVerificationFormPath = @"/ach/verificationForm";

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
		[weakSelf.workModel.managedObjectContext performBlock:^{			
			if (response[@"fieldGroups"] && response[@"bankName"])
			{
				NSString* bankName = response[@"bankName"];
				[weakSelf.workModel createOrUpdateAchBankWithData:response[@"fieldGroups"]
														 bankTitle:bankName];
				[weakSelf.workModel saveContext:^{
					weakSelf.resultHandler(nil, [weakSelf.workModel bankWithTitle:bankName]);
				}];
			}
			else
			{
				weakSelf.resultHandler(nil, nil);
			}
		}];
	}];
	
	[self getDataFromPath:path params:@{@"routingNumber" : self.routingNumber,
										@"accountNumber" : self.accountNumber,
										@"paymentId" : self.paymentId}];
	
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
