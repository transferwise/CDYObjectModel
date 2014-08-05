//
//  EmailEntryCell.m
//  Transfer
//
//  Created by Juhan Hion on 05.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "EmailEntryCell.h"

NSString *const TWEmailEntryCellIdentifier = @"EmailEntryCell";

@interface EmailEntryCell ()<UITextFieldDelegate>

@end

@implementation EmailEntryCell

- (void)textFieldEntryFinished
{
	//trigger validation on delegate
}

@end
