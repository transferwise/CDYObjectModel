//
//  ZipCityCell.m
//  Transfer
//
//  Created by Juhan Hion on 31.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DoubleEntryCell.h"
#import "FloatingLabelTextField.h"

NSString *const TWDoubleEntryCellIdentifier = @"DoubleEntryCell";

@interface DoubleEntryCell ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *firstTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *secondTextField;

@property (strong, nonatomic) UIView* secondSeparator;

@end

@implementation DoubleEntryCell

NSInteger const kFirstTextField = 1;
NSInteger const kSecondTextField = 2;

#pragma mark - Init and Configuration
- (void)awakeFromNib
{
	[super awakeFromNib];
	[self commonSetup];
}

- (void)commonSetup
{
	self.firstTextField.delegate = self;
	self.secondTextField.delegate = self;
	
	[self.firstTextField setReturnKeyType:UIReturnKeyNext];
    [self.secondTextField setReturnKeyType:UIReturnKeyNext];
}

- (void)setAutoCapitalization:(UITextAutocapitalizationType)capitalizationType
{
	self.firstTextField.autocapitalizationType = capitalizationType;
	self.secondTextField.autocapitalizationType = capitalizationType;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self addDoubleSeparators];
}

- (void)updateConstraints
{
	[super updateConstraints];
	
	//make textfields half the width of the cell minus separators
	NSLayoutConstraint *firstWidth = [NSLayoutConstraint constraintWithItem:self.firstTextField
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeWidth
																multiplier:.5f
																  constant:-30];
	NSLayoutConstraint *secondWidth = [NSLayoutConstraint constraintWithItem:self.secondTextField
																 attribute:NSLayoutAttributeWidth
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.contentView
																 attribute:NSLayoutAttributeWidth
																multiplier:.5f
																  constant:-30];
	[self.contentView addConstraints:@[firstWidth, secondWidth]];
}

- (void)setFirstTitle:(NSString *)title
{
	[self.firstTextField setTitle:title];
}

#pragma mark - Multiple Entry Cell
- (void)configureWithTitle:(NSString *)title
					 value:(NSString *)value
				 secondTitle:(NSString *)secondTitle
				 secondValue:(NSString *)secondValue
{
	[self.firstTextField configureWithTitle:title value:value];
	[self.secondTextField configureWithTitle:secondTitle value:secondValue];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	[self configureWithTitle:title value:value secondTitle:@"" secondValue:@""];
}

#pragma mark - Values
- (NSString *)value
{
	return self.firstTextField.text;
}

- (void)setValue:(NSString *)value
{
	self.firstTextField.text = value;
}

- (NSString *)secondValue
{
	return self.secondTextField.text;
}

- (void)setSecondValue:(NSString *)secondValue
{
	self.secondTextField.text = secondValue;
}

- (BOOL)editable
{
	return self.firstTextField.enabled && self.secondTextField.enabled;
}

- (void)setEditable:(BOOL)value
{
	self.firstTextField.enabled = value;
	[TextEntryCell setTextColor:self.firstTextField editable:value];
}

- (void)setSecondEditable:(BOOL)value
{
	self.secondTextField.enabled = value;
	[TextEntryCell setTextColor:self.secondTextField editable:value];
}

#pragma mark - Navigation between fields
- (void)activate
{
	if (!self.editable)
	{
		return;
	}
	
	if (self.firstTextField.enabled)
	{
		[self.firstTextField becomeFirstResponder];
	}
	else if (self.secondTextField.enabled)
	{
		[self.secondTextField becomeFirstResponder];
	}
}

- (BOOL)shouldNavigateAway
{
	return self.selectedTextField.tag == kSecondTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField.tag == kFirstTextField)
	{
		if (self.secondTextField.enabled)
		{
			[self.secondTextField becomeFirstResponder];
		}
		else
		{
			[self navigateAway:textField];
		}
	}
	else if (textField.tag == kSecondTextField)
	{
		[self navigateAway:textField];
	}
	
	return YES;
}

- (void)navigateAway:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self navigateAway];
}
@end
