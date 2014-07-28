//
//  MultipleEntryCell.m
//  Transfer
//
//  Created by Juhan Hion on 28.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "MultipleEntryCell.h"
#import "Constants.h"

@interface MultipleEntryCell ()

@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, strong) UITextField* selectedTextField;

@end

@implementation MultipleEntryCell

#pragma mark - TextEntryCell overridess
- (UITextField *)entryField
{
	return nil;
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	ABSTRACT_METHOD;
}

- (NSString *)value
{
	ABSTRACT_METHOD;
	return nil;
}

- (void)setValue:(NSString *)value
{
    ABSTRACT_METHOD;
}

- (BOOL)editable
{
	ABSTRACT_METHOD;
	return NO;
}

- (void)setEditable:(BOOL)editable
{
	ABSTRACT_METHOD;
}

- (void)setValueWhenEditable:(NSString *)value
{
    ABSTRACT_METHOD;
}

#pragma mark - Navigation between fields
- (void)activate
{
	ABSTRACT_METHOD;
}

- (BOOL)shouldNavigateAway
{
	ABSTRACT_METHOD;
	return NO;
}

- (void)navigateAway
{
	if(self.delegate)
	{
		[self.delegate navigateAwayFrom:self];
	}
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	self.selectedTextField = textField;
	return YES;
}

@end
