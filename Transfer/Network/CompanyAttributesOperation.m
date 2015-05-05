//
//  CompanyAttributesOperation.m
//  Transfer
//
//  Created by Juhan Hion on 05.05.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CompanyAttributesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Users.h"

NSString *const kCompanyAttributesOperationPath = @"/user/companyAttributes";

@implementation CompanyAttributesOperation

- (void)execute
{
	MCAssert(self.objectModel);
	
	NSString *path = [self addTokenToPath:kCompanyAttributesOperationPath];
	
	__weak CompanyAttributesOperation *weakSelf = self;
	
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		if (response[@"companyTypes"] && response[@"companyRoles"])
		{
			for (NSDictionary *companyType in response[@"companyTypes"])
			{
				[weakSelf.objectModel saveAdditionalAttributeWithType:CompanyType
																  code:companyType[@"id"]
																title:companyType[@"title"]];
			}
			
			for (NSDictionary *companyRole in response[@"companyRoles"])
			{
				[weakSelf.objectModel saveAdditionalAttributeWithType:CompanyRole
																  code:companyRole[@"id"]
																title:companyRole[@"title"]];
			}
		}
		
		weakSelf.resultHandler(nil);
	}];
	
	[self getDataFromPath:path];
}

+ (CompanyAttributesOperation *)operation
{
	CompanyAttributesOperation *operation = [[CompanyAttributesOperation alloc] init];
	operation.isAnonymous = YES;
	
	return operation;
}

@end
