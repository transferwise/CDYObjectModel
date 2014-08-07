//
//  TextEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"
#import "UIColor+Theme.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"
#import "MOMStyle.h"
#import <JVFloatLabeledTextField.h>
#import "UIView+SeparatorLine.h"

NSString *const TWTextEntryCellIdentifier = @"TextEntryCell";

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, assign) BOOL valueModified;
@property (nonatomic, strong) IBOutlet UIButton *errorButton;
@property (nonatomic, copy) NSString *validationIssue;
@property (nonatomic, strong) UIView* maskView;

- (IBAction)errorButtonTapped;

@end

@implementation TextEntryCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    if (!self.separatorLine)
    {
        self.separatorLine = [UIView getSeparatorLineWithParentFrame:self.contentView.frame];
        [self.contentView addSubview:self.separatorLine];
    }
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
    [self.entryField setPlaceholder:title];
    [self setValue:value];
	[self.entryField addTarget:self action:@selector(editingEnded) forControlEvents:UIControlEventEditingDidEnd];
}

- (NSString *)value
{
    if([self.entryField text])
        return [self.entryField text];
    else
        return @"";
}

- (void)setValue:(NSString *)value
{
    [self.entryField setText:value];
}

- (void)setEditable:(BOOL)editable
{
    [self.entryField setEnabled:editable];
    [self.entryField setTextColor:(editable ? [UIColor colorFromStyle:self.entryField.fontStyle] : [UIColor disabledEntryTextColor])];
}

- (BOOL)editable
{
	return [self.entryField isEnabled];
}

- (void)setValueWhenEditable:(NSString *)value
{
    if (![self.entryField isEnabled])
	{
        return;
    }

    [self.entryField setText:value];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *modified = [self.entryField.text stringByReplacingCharactersInRange:range withString:string];
	if(![self validateAlphaNumeric:modified])
	{
		return NO;
	}
	
	if (self.maxValueLength == 0)
	{
        return YES;
    }
	
	if (self.maxValueLength > 0 && [modified length] > self.maxValueLength)
	{
        return NO;
    }
	
    [self setValueModified:YES];
    return YES;
}

- (void)textFieldEntryFinished
{
	//used in inheriting classes
}

- (void)editingEnded
{
	if ([self.delegate respondsToSelector:@selector(textEntryFinishedInCell:)])
	{
		[self.delegate textEntryFinishedInCell:self];
	}
}

- (void)markIssue:(NSString *)issueMessage
{
    [self setValidationIssue:issueMessage];
    [self.errorButton setHidden:!self.valueModified || ![issueMessage hasValue] || [self.entryField isFirstResponder]];
}

- (IBAction)errorButtonTapped
{
    if (![self.validationIssue hasValue])
	{
        return;
    }

    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:self.entryField.placeholder message:self.validationIssue];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    [alertView show];
}

- (void)markTouched
{
    [self setValueModified:YES];
}

- (BOOL)validateAlphaNumeric:(NSString *)value
{
	if(!self.validateAlphaNumeric)
	{
		return YES;
	}
	
	NSMutableCharacterSet *alphanumerics = [NSMutableCharacterSet alphanumericCharacterSet];
	[alphanumerics addCharactersInString:@"."];
	NSCharacterSet *unwantedCharacters = [alphanumerics invertedSet];
	
    return ([value rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}

- (void)setGrayedOut:(BOOL)isGrayedOut
{
	if (isGrayedOut)
	{
		if (!self.maskView)
		{
			self.maskView = [[UIView alloc] initWithFrame:self.contentView.frame];
			self.maskView.backgroundColor = [UIColor colorFromStyle:@"white"];
			self.maskView.alpha = 0.6f;
		}
		
		[self.contentView addSubview:self.maskView];
		[self.contentView bringSubviewToFront:self.maskView];
	}
	else
	{
		if (self.maskView && self.maskView.superview)
		{
			[self.maskView removeFromSuperview];
		}
	}
	
	self.editable = !isGrayedOut;
	self.userInteractionEnabled = !isGrayedOut;
}

@end
