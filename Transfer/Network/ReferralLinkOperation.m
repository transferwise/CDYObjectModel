//
//  ReferralLinkOperation.m
//  Transfer
//
//  Created by Juhan Hion on 21.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ReferralLinkOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"

NSString *const kReferralLinkPath = @"/referral/link";

@implementation ReferralLinkOperation

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kReferralLinkPath];
	
	__weak ReferralLinkOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error, nil);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		NSString* referralLink;
		if (response[@"referralLink"])
		{
			referralLink = response[@"referralLink"];
		}
		weakSelf.resultHandler(nil, referralLink);
	}];
	
	[self getDataFromPath:path params:@{@"inviteSource" : TRWAppType}];
}

+ (ReferralLinkOperation *)operation
{
	return [[ReferralLinkOperation alloc] init];
}

@end
