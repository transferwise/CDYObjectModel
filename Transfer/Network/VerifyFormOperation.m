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
		if (response[@"status"])
		{
			//check if we are dealing with MFA
			if ([[weakSelf class] isMfa:response])
			{
				NSString* bankName = response[@"bankName"];
				NSString* fieldType = response[@"fieldType"];
				
				[weakSelf.objectModel createOrUpdateAchBankWithData:response[@"fieldGroups"]
														  bankTitle:bankName
															 formId:response[@"verifiableAccountId"]
														  fieldType:fieldType
															 itemId:response[@"itemId"]];
				[weakSelf.objectModel saveContext:^{
					weakSelf.resultHandler(nil, [@"success" caseInsensitiveCompare:response[@"status"]] == NSOrderedSame, [weakSelf.workModel bankWithTitle:bankName
																																				  fieldType:fieldType]);
				}];

			}
			else
			{
				weakSelf.resultHandler(nil, [@"success" caseInsensitiveCompare:response[@"status"]] == NSOrderedSame, nil);
			}
		}
	}];
	
	[self postData:self.data toPath:path timeOut:kVerifyFormExtendedTimeout];
}

+ (BOOL)isMfa:(NSDictionary *)response
{
	return response[@"fieldGroups"] && response[@"bankName"] && response[@"fieldType"] && response[@"itemId"];
}

@end
