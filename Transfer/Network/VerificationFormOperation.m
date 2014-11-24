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

//TODO: this is probably going to change to just verificationform
NSString *const kVerificationFormPath = @"/ach/getVerificationForm";

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
		if (response[@"fieldGroups"])
		{
			NSDictionary *form = [[NSDictionary alloc] init];
			
			for (NSDictionary* group in response[@"fieldGroups"])
			{
				NSString* title = group[@"title"];
				NSMutableArray *fields = [[NSMutableArray alloc] init];
				
				for (NSDictionary* row in group[@"fields"])
				{
					[fields addObject:[TypeFieldParser getTypeWithData:row
															nameGetter:^NSString *{
																return title;
															}
														   fieldGetter:^RecipientTypeField *(NSString *name) {
															   RecipientTypeField *field = [[RecipientTypeField alloc] init];
															   [field setName:name];
															   return field;
														   }
														   valueGetter:^AllowedTypeFieldValue *(RecipientTypeField *field, NSString *code) {
															   AllowedTypeFieldValue *value = [[AllowedTypeFieldValue alloc] init];
															   [value setCode:code];
															   [value setValueForField:field];
															   return value;
														   }]];
				}
				
				[form setValue:fields forKey:title];
			}
			
			weakSelf.resultHandler(nil, form);
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
