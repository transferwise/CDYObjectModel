//
//  RemoveUserDeviceOperation.m
//  Transfer
//
//  Created by Juhan Hion on 14.04.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "RemoveUserDeviceOperation.h"
#import "TransferwiseOperation+Private.h"
#import "ObjectModel+Users.h"

NSString *const kUserDeviceRemovePath = @"/device/remove";

@implementation RemoveUserDeviceOperation

- (void)execute
{
	MCAssert(self.objectModel);
	
	__block __weak RemoveUserDeviceOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		MCLog(@"Error %@", error);
		weakSelf.completionHandler(error);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		if ([response[@"status"] isEqualToString:@"success"])
		{
			[weakSelf.workModel.managedObjectContext performBlock:^{
				[weakSelf.workModel saveDeviceToken:nil];
				
				[weakSelf.workModel saveContext:^{
					weakSelf.completionHandler(nil);
				}];
			}];
		}
	}];
	
	NSString *fullPath = [self addTokenToPath:kUserDeviceRemovePath];
	NSDictionary *data = @{@"deviceToken" : self.token};
	[self postData:data
			toPath:fullPath];
}

+ (RemoveUserDeviceOperation *)removeDeviceOperation
{
	return [[RemoveUserDeviceOperation alloc] init];
}

@end
