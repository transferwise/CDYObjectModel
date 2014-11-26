//
//  TransparentModalViewControllerDelegateHelper.m
//  Transfer
//
//  Created by Juhan Hion on 26.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewControllerDelegateHelper.h"

@interface TransparentModalViewControllerDelegateHelper ()

@property (nonatomic, copy) TRWActionBlock completion;

@end

@implementation TransparentModalViewControllerDelegateHelper

- (instancetype)initWithCompletion:(TRWActionBlock)completion
{
	self = [super init];
	if (self)
	{
		self.completion = completion;
	}
	return self;
}

- (void)dismissCompleted:(TransparentModalViewController *)dismissedController
{
	self.completion();
}

@end
