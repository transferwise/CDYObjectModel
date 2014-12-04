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
#import "ObjectModel+Users.h"

NSString *const kReferralListPath = @"/referral/list";

@implementation ReferralListOperation

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kReferralListPath];
	
	__weak ReferralListOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
        if(weakSelf.resultHandler)
        {
            weakSelf.resultHandler(error);
        }
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		
                [weakSelf.workModel saveReferralData:response];
				[weakSelf.workModel saveContext:^{
                    if(weakSelf.resultHandler)
                    {
                        weakSelf.resultHandler(nil);
                    }
				}];
	}];
	
	[self getDataFromPath:path params:nil];
}

+ (ReferralListOperation *)operation
{
	return [[ReferralListOperation alloc] init];
}

@end
