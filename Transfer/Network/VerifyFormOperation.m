//
//  VerifyFormOperation.m
//  Transfer
//
//  Created by Juhan Hion on 27.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "VerifyFormOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+AchBank.h"
#import "AchResponseParser.h"

#define kVerifyFormExtendedTimeout 180

NSString *const kVerifyFormPath = @"/ach/verify";

@interface VerifyFormOperation ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation VerifyFormOperation

- (NSString*)apiVersion
{
	//v2 contains MFA
	return @"v2";
}

+ (VerifyFormOperation *)verifyFormOperationWithData:(NSDictionary *)data
{
	return [[VerifyFormOperation alloc] initWithData:data];
}

- (instancetype)initWithData:(NSDictionary *)data
{
	self = [super init];
	if (self)
	{
		self.data = data;
	}
	return  self;
}

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kVerifyFormPath];
	
	__weak VerifyFormOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error, NO, nil);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		AchResponseParser *parser = [[AchResponseParser alloc] initWithResponse:response];
		
		if (parser.hasStatus)
		{
			//check if we are dealing with MFA
			if (parser.isMfa)
			{
				NSString* bankName = parser.BankName;
				NSString* fieldType = parser.FieldType;
				
				[weakSelf.objectModel createOrUpdateAchBankWithData:parser.FieldGroups
														  bankTitle:bankName
															 formId:parser.VerifiableAccountId
														  fieldType:fieldType
															 itemId:parser.ItemId
														  mfaFields:parser.getMfaFields];
				[weakSelf.objectModel saveContext:^{
					weakSelf.resultHandler(nil, parser.isSuccessful, [weakSelf.workModel bankWithTitle:bankName
																							 fieldType:fieldType]);
				}];
			}
			else
			{
				weakSelf.resultHandler(nil, parser.isSuccessful, nil);
			}
		}
	}];
	
	[self postData:self.data toPath:path timeOut:kVerifyFormExtendedTimeout];
}

@end
