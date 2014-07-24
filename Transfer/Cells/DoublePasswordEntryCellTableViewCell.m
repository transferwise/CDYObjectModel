//
//  DoublePasswordEntryCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 24.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DoublePasswordEntryCellTableViewCell.h"
#import "FloatingLabelTextField.h"

@interface DoublePasswordEntryCellTableViewCell ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *firstPassword;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *secondPawword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstPasswordWidth;

@end

@implementation DoublePasswordEntryCellTableViewCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self.firstPassword configureWithTitle:NSLocalizedString(@"personal.profile.password.label", nil) value:@""];
	[self.firstPassword configureWithTitle:NSLocalizedString(@"personal.profile.password.confirm.label", nil) value:@""];
}

- (void)prepareForReuse
{
	self.useDummyPassword = NO;
}

- (BOOL)areMatching
{
	if (self.showDouble && !self.useDummyPassword)
	{
		return [self.firstPassword.text isEqualToString:self.self.secondPawword.text];
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
	[self.firstPassword setText:@"asdfasdf"];
	[self.secondPawword setText:@"asdfasdf"];
	self.useDummyPassword = YES;
}

@end
