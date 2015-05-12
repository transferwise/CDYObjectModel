//
//  AddUserDeviceOperation.m
//  Transfer
//
//  Created by Juhan Hion on 14.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "AddUserDeviceOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Users.h"

NSString *const kUserDeviceAddPath = @"/device/add";

@implementation AddUserDeviceOperation

- (void)execute
{
	MCAssert(self.objectModel);
	
	__block __weak AddUserDeviceOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		MCLog(@"Error %@", error);
		weakSelf.completionHandler(error);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		if ([response[@"status"] isEqualToString:@"success"])
		{
			[weakSelf.workModel.managedObjectContext performBlock:^{
				[weakSelf.workModel saveDeviceToken:weakSelf.token];
				
				[weakSelf.workModel saveContext:^{
					weakSelf.completionHandler(nil);
				}];
			}];
		}
	}];
	
	NSString *fullPath = [self addTokenToPath:kUserDeviceAddPath];
	NSDictionary *data = @{@"deviceToken" : self.token,
							 @"deviceName" : [[UIDevice currentDevice] name]};
	[self postData:data
			toPath:fullPath];
}

+ (AddUserDeviceOperation *)addDeviceOperation
{
	return [[AddUserDeviceOperation alloc] init];
}

@end
