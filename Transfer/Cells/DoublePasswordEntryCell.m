//
//  DoublePasswordEntryCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 24.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DoublePasswordEntryCell.h"
#import "FloatingLabelTextField.h"

NSString *const TWDoublePasswordEntryCellIdentifier = @"DoublePasswordEntryCell";

@interface DoublePasswordEntryCell ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *secondPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstPasswordWidth;

@end

@implementation DoublePasswordEntryCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self configureWithTitle:NSLocalizedString(@"personal.profile.password.label", nil) value:@""];
	[self.secondPassword configureWithTitle:NSLocalizedString(@"personal.profile.password.confirm.label", nil) value:@""];
}

- (void)prepareForReuse
{
	self.useDummyPassword = NO;
}

- (BOOL)areMatching
{
	if (self.showDouble && !self.useDummyPassword)
	{
		return [self.entryField.text isEqualToString:self.self.secondPassword.text];
	}
	
	return YES;
}

- (void)setShowDouble:(BOOL)showDouble
{
	if (showDouble)
	{
		self.firstPasswordWidth.constant = 0;
	}
	else
	{
		self.firstPasswordWidth.constant = 1000;
	}
}

- (void)setDummyPassword
{
	[self.entryField setText:@"asdfasdf"];
	[self.secondPassword setText:@"asdfasdf"];
	self.useDummyPassword = YES;
}

@end
