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

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *firstPassword;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *secondPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstPasswordWidth;

@end

@implementation DoublePasswordEntryCell

NSInteger const kFirstPassword = 1;
NSInteger const kSecondPassword = 2;

#pragma mark - Init and Configuration
- (void)awakeFromNib
{
	[super awakeFromNib];
	[self commonSetup];
}

- (void)commonSetup
{
	self.firstPassword.delegate = self;
	self.secondPassword.delegate = self;
}

#pragma mark - Multiple Entry Cell

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	[self.firstPassword configureWithTitle:title value:@""];
	[self.secondPassword configureWithTitle:NSLocalizedString(@"personal.profile.password.confirm.label", nil) value:@""];
}

- (NSString *)value
{
	return self.firstPassword.text;
}

- (BOOL)editable
{
	if (self.showDouble)
	{
		return [self.firstPassword isEnabled]
			&& [self.secondPassword isEnabled];
	}
	else
	{
		return [self.firstPassword isEnabled];
	}
}

- (void)setEditable:(BOOL)editable
{
	self.firstPassword.enabled = editable;
	self.secondPassword.enabled = editable;
}

#pragma mark - Navigation between fields
- (void)activate
{
	if (self.useDummyPassword)
	{
		self.firstPassword.text = @"";
	}
	
	[self.firstPassword becomeFirstResponder];
}

- (BOOL)shouldNavigateAway
{
	if (self.showDouble)
	{
		return self.selectedTextField.tag == kSecondPassword;
	}
	
	return self.selectedTextField.tag == kFirstPassword;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (self.showDouble)
	{
		if (textField.tag == kFirstPassword)
		{
			if (self.useDummyPassword)
			{
				self.secondPassword.text = @"";
			}
			
			[self.secondPassword becomeFirstResponder];
			return YES;
		}
		else if (textField.tag == kSecondPassword)
		{
			if (self.areMatching)
			{
				//trigger year validation
				[textField resignFirstResponder];
				[self navigateAway];
				return YES;
			}
			else
			{
				//add validation error to self.
				return NO;
			}
		}
		
		return YES;
	}
	else
	{
		[self.firstPassword resignFirstResponder];
		[self navigateAway];
		return YES;
	}
}

#pragma mark - Double Password
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
		[self addDoubleSeparators];
	}
	else
	{
		self.firstPasswordWidth.constant = 1000;
		[self removeDoubleSeparators];
	}
	
	_showDouble = showDouble;
}

- (void)setDummyPassword
{
	[self.entryField setText:@"asdfasdf"];
	[self.secondPassword setText:@"asdfasdf"];
	self.useDummyPassword = YES;
}

@end