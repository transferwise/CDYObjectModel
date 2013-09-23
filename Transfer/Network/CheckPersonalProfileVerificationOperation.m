//
//  CheckPersonalProfileVerificationOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 9/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CheckPersonalProfileVerificationOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"

NSString *const kCheckVerificationPath = @"/verification/required";

@implementation CheckPersonalProfileVerificationOperation

- (void)execute {
	NSString *path = [self addTokenToPath:kCheckVerificationPath];

	__weak CheckPersonalProfileVerificationOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(IdentificationNoneRequired);
	}];

	[self setOperationSuccessHandler:^(NSDictionary *response) {
		IdentificationRequired identificationRequired = IdentificationNoneRequired;
		if ([response[@"idVerification"] boolValue]) {
			identificationRequired = identificationRequired | IdentificationIdRequired;
		}
		if ([response[@"addressVerification"] boolValue]) {
			identificationRequired = identificationRequired | IdentificationAddressRequired;
		}
		weakSelf.resultHandler(identificationRequired);
	}];

	[self getDataFromPath:path params:@{@"profile" : @"personal"}];
}

+ (CheckPersonalProfileVerificationOperation *)operation {
	return [[CheckPersonalProfileVerificationOperation alloc] init];
}

@end