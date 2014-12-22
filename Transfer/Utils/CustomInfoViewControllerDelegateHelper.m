//
//  CustomInfoViewControllerDelegateHelper.m
//  Transfer
//
//  Created by Juhan Hion on 26.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewControllerDelegateHelper.h"

@interface CustomInfoViewControllerDelegateHelper ()

@end

@implementation CustomInfoViewControllerDelegateHelper

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
