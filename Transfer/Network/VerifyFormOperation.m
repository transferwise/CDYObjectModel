//
//  VerifyFormOperation.m
//  Transfer
//
//  Created by Juhan Hion on 27.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "VerifyFormOperation.h"
#import "Constants.h"
#import "TransferwiseOperation+Private.h"

NSString *const kVerifyFormPath = @"/ach/verify";

@interface VerifyFormOperation ()

@property (nonatomic, strong) NSDictionary *data;

@end

@implementation VerifyFormOperation

+ (VerifyFormOperation *)verifyFormOperationWithData:(NSDictionary *)data
{
	return [[VerifyFormOperation alloc] initWithData:data];
}

- (instancetype)initWithData:(NSDictionary *)data
{
	self = [super init];
	if (self)
	{
		self.data = data;
	}
	return  self;
}

- (void)execute
{
	MCLog(@"execute");
	NSString *path = [self addTokenToPath:kVerifyFormPath];
	
	__weak VerifyFormOperation *weakSelf = self;
	[self setOperationErrorHandler:^(NSError *error) {
		weakSelf.resultHandler(error);
	}];
	
	[self setOperationSuccessHandler:^(NSDictionary *response) {
		
	}];
	
	[self postData:self.data toPath:path];
}

@end
