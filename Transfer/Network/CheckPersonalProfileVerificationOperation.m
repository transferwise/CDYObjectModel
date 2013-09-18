//
//  CheckPersonalProfileVerificationOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 9/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CheckPersonalProfileVerificationOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kCheckVerificationPath = @"/verification/required";

@implementation CheckPersonalProfileVerificationOperation

- (void)execute {
	NSString *path = [self addTokenToPath:kCheckVerificationPath];

	__weak CheckPersonalProfileVerificationOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(NO);
	}];

	[self setOperationSuccessHandler:^(NSDictionary *response) {
		BOOL idVerification = [response[@"idVerification"] boolValue];
		BOOL addressVerification = [response[@"addressVerification"] boolValue];
		weakSelf.resultHandler(idVerification || addressVerification);
	}];

	[self getDataFromPath:path params:@{@"profile" : @"personal"}];
}

+ (CheckPersonalProfileVerificationOperation *)operation {
	return [[CheckPersonalProfileVerificationOperation alloc] init];
}

@end
