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
#import "ObjectModel+ReferralLinks.h"

NSString *const kReferralLinksPath = @"/referral/links";

@implementation ReferralLinksOperation

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kReferralLinksPath];
	
	__weak ReferralLinksOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error);
	}];
	
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        if (response[@"referralLinks"])
        {
            NSDictionary *referralLinks = response[@"referralLinks"];
            if (referralLinks)
            {
                [weakSelf.workModel performBlock:^{
                    [weakSelf.workModel createOrUpdateReferralLinks:referralLinks];
                    [weakSelf.workModel saveContext:^{
                        weakSelf.resultHandler(nil);
                    }];
                }];
            }
        }
        else
		{
			weakSelf.resultHandler(nil);
		}
	}];
	
	[self getDataFromPath:path params:@{@"invitePlatform" : TRWAppType}];
}

+ (ReferralLinksOperation *)operation
{
	return [[ReferralLinksOperation alloc] init];
}

@end
