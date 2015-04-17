//
//  UpdateUserDeviceOperation.m
//  Transfer
//
//  Created by Juhan Hion on 14.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "UpdateUserDeviceOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Users.h"

NSString *const kUserDeviceUpdatePath = @"/device/update";

@implementation UpdateUserDeviceOperation

- (void)execute
{
	MCAssert(self.objectModel);
	
	__block __weak UpdateUserDeviceOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		MCLog(@"Error %@", error);
		weakSelf.completionHandler(error);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		if ([response[@"status"] isEqualToString:@"success"])
		{
			[weakSelf.workModel.managedObjectContext performBlock:^{
				[weakSelf.workModel saveDeviceToken:weakSelf.updatedToken];
				
				[weakSelf.workModel saveContext:^{
					weakSelf.completionHandler(nil);
				}];
			}];
		}
	}];
	
	NSString *fullPath = [self addTokenToPath:kUserDeviceUpdatePath];
	NSDictionary *data = @{@"existingDeviceToken" : self.existingToken,
							 @"newDeviceToken" : self.updatedToken};
	[self postData:data
			toPath:fullPath];
}

+ (UpdateUserDeviceOperation *)updateDeviceOperation
{
	return [[UpdateUserDeviceOperation alloc] init];
}

@end
