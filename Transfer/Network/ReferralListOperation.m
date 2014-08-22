//
//  ReferralListOperation.m
//  Transfer
//
//  Created by Juhan Hion on 22.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ReferralListOperation.h"
#import "TransferwiseOperation+Private.h"
#import "constants.h"

NSString *const kReferralListPath = @"/referral/list";

@implementation ReferralListOperation

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kReferralListPath];
	
	__weak ReferralListOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error, INT16_MIN);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		//this is a naive count op, response contains more useful stuff
		if (response
			&& response[@"successfulReferrals"]
			&& (NSDictionary *)response[@"successfulReferrals"])
		{
			weakSelf.resultHandler(nil, [response[@"successfulReferrals"] count]);
		}
		else
		{
			//no error, but no result either
			weakSelf.resultHandler(nil, INT16_MIN);
		}
	}];
	
	[self getDataFromPath:path params:nil];
}

+ (ReferralListOperation *)operation
{
	return [[ReferralListOperation alloc] init];
}

@end
