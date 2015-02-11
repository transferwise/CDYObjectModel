//
//  AchResponseParser.m
//  Transfer
//
//  Created by Juhan Hion on 11.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "AchResponseParser.h"
#import "AchBank.h"

static NSString *const FIELD_GROUPS = @"fieldGroups";
static NSString *const VERIFIABLE_ACCOUNT_ID = @"verifiableAccountId";
static NSString *const FIELD_TYPE = @"fieldType";
static NSString *const ITEM_ID = @"itemId";
static NSString *const BANK_NAME = @"bankName";
static NSString *const STATUS = @"status";
static NSString *const SUCCESS = @"success";

@interface AchResponseParser ()

@property (strong, nonatomic) NSDictionary *response;

@end

@implementation AchResponseParser

#pragma mark - Init
- (instancetype)initWithResponse:(NSDictionary *)response
{
	self = [super init];
	if (self)
	{
		self.response = response;
	}
	return self;
}

#pragma mark - Field Checks
- (BOOL)hasStatus
{
	return self.response[STATUS] ? YES : NO;
}

- (BOOL)isSuccessful
{
	return [SUCCESS caseInsensitiveCompare:self.response[STATUS]] == NSOrderedSame;
}

- (BOOL)isLogin
{
	return self.response[FIELD_GROUPS]
			&& self.response[BANK_NAME];
}

- (BOOL)isMfa
{
	return self.response[FIELD_GROUPS]
			&& self.response[BANK_NAME]
			&& self.response[FIELD_TYPE]
			&& self.response[ITEM_ID];
}

#pragma mark - Field Values
- (NSString *)BankName
{
	return self.response[BANK_NAME];
}

- (NSString *)FieldType
{
	return self.response[FIELD_TYPE];
}

- (NSString *)VerifiableAccountId
{
	return self.response[VERIFIABLE_ACCOUNT_ID];
}

- (NSString *)ItemId
{
	return self.response[ITEM_ID];
}

- (NSDictionary *)FieldGroups
{
	return self.response[FIELD_GROUPS];
}

#pragma mark - Submit Dict
+ (NSMutableDictionary *)initFormValues:(AchBank *)bank
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setValue:bank.id forKey:@"verifiableAccountId"];
	
	if (bank.fieldType)
	{
		[dict setValue:bank.fieldType forKey:@"fieldType"];
	}
	
	if ([bank.itemId intValue] > 0)
	{
		[dict setValue:[bank.itemId stringValue] forKey:@"itemId"];
	}
	
	return dict;
}

@end
