//
//  DoublePasswordEntryCellTableViewCell.m
//  Transfer
//
//  Created by Juhan Hion on 24.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DoublePasswordEntryCell.h"
#import "FloatingLabelTextField.h"
#import "UIView+SeparatorLine.h"

NSString *const TWDoublePasswordEntryCellIdentifier = @"DoublePasswordEntryCell";

@interface DoublePasswordEntryCell ()

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *secondPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstPasswordWidth;
@property (strong, nonatomic) UIView* secondSeparator;

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
		[self addDoubleSeparators];
	}
	else
	{
		self.firstPasswordWidth.constant = 1000;
		[self removeDoubleSeparators];
	}
}

- (void)setDummyPassword
{
	[self.entryField setText:@"asdfasdf"];
	[self.secondPassword setText:@"asdfasdf"];
	self.useDummyPassword = YES;
}

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
	
	//Why the hell do I need to subtract -10.f??. Should this account for scale?
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
