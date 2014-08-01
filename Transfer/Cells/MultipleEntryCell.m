//
//  MultipleEntryCell.m
//  Transfer
//
//  Created by Juhan Hion on 28.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "MultipleEntryCell.h"
#import "Constants.h"
#import "UIView+SeparatorLine.h"

@interface MultipleEntryCell ()

@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, strong) UITextField* selectedTextField;

@end

@implementation MultipleEntryCell

#pragma mark - Init
- (void)awakeFromNib
{
	[super awakeFromNib];
	//remove separator, because multiple fields require multiple separators
	self.separatorLine = [[UIView alloc] init];
}

#pragma mark - TextEntryCell overrides
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

#pragma mark - Helpers for cells containing two equal length entry fields
- (void)addDoubleSeparators
{
	self.separatorLine = [UIView getSeparatorLineWithParentFrame:[self getHalfWidthFrame:YES]];
	[self.contentView addSubview:self.separatorLine];
	self.secondSeparator = [UIView getSeparatorLineWithParentFrame:[self getHalfWidthFrame:NO]];
	[self.contentView addSubview:self.secondSeparator];
}

- (CGRect)getHalfWidthFrame:(BOOL)firstHalf
{
	CGRect frame = self.contentView.frame;
	CGFloat halfWidth = frame.size.width / 2;
	
	return CGRectMake(firstHalf ? frame.origin.x : (frame.origin.x + halfWidth), frame.origin.y, firstHalf ? halfWidth - 10.f : halfWidth, frame.size.height);
}

- (void)removeDoubleSeparators
{
	//only remove if there is a second view and it is visible
	if(self.secondSeparator && self.secondSeparator.superview)
	{
		[self.separatorLine removeFromSuperview];
		[self.secondSeparator removeFromSuperview];
		self.secondSeparator = nil;
		
		self.separatorLine = [UIView getSeparatorLineWithParentFrame:self.contentView.frame];
		[self.contentView addSubview:self.separatorLine];
	}
}

@end
