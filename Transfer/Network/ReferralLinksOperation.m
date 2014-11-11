//
//  ReferralLinksOperation.m
//  Transfer
//
//  Created by Juhan Hion on 11.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ReferralLinksOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Users.h"

NSString *const kReferralLinksPath = @"/referral/links";

@implementation ReferralLinksOperation

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kReferralLinksPath];
	
	__weak ReferralLinksOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error, nil);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		NSDictionary* referralLinks;
		if (response[@"referralLinks"])
		{
			referralLinks = response[@"referralLinks"];
//			[weakSelf.workModel saveInviteUrl:referralLink];
//			[weakSelf.workModel saveContext:^{
//				weakSelf.resultHandler(nil, referralLink);
//			}];
		}
		else
		{
			weakSelf.resultHandler(nil, referralLinks);
		}
	}];
	
	[self getDataFromPath:path params:@{@"inviteSource" : TRWAppType}];
}

+ (ReferralLinksOperation *)operation
{
	return [[ReferralLinksOperation alloc] init];
}

@end
