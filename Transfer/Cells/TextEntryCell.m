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
#import "NSString+Presentation.h"
#import "UITextField+CaretPosition.h"

NSString *const TWTextEntryCellIdentifier = @"TextEntryCell";

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, assign) BOOL valueModified;
@property (nonatomic, strong) IBOutlet UIButton *errorButton;
@property (nonatomic, copy) NSString *validationIssue;
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, strong) NSCharacterSet *englishCharacterExclusionSet;

- (IBAction)errorButtonTapped;

@end

@implementation TextEntryCell

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
    [TextEntryCell setTextColor:self.entryField editable:editable];
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
    NSString* originalText = textField.text?:@"";
    if(self.validateAlphaNumeric)
    {
        string = [self stripAccentsFromString:string];
    }
    
	NSString *modified = [originalText stringByReplacingCharactersInRange:range withString:string];
    NSRange caretRange = NSMakeRange(range.location, [string length]);
    
    
    NSString *pattern = self.presentationPattern;
    
    if([pattern hasValue])
    {
        if ([pattern hasValue] && [modified length] > [pattern length])
        {
            return NO;
        }
        
        if ([string length] == 0)
        {
            modified = [modified stringByRemovingPatterChar:pattern];
        }
        else
        {
            modified = [modified applyPattern:pattern];
            modified = [modified stringByAddingPatternChar:pattern];
        }

    }
    else
    {
        if (self.maxValueLength > 0 && [modified length] > self.maxValueLength)
        {
            return NO;
        }
    }
    
    
    textField.text = modified;
    if(![pattern hasValue] && caretRange.location + caretRange.length < [modified length])
    {
        [self.entryField moveCaretToAfterRange:caretRange];
    }
    [self setValueModified:YES];
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    return NO;

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

- (void)setGrayedOut:(BOOL)isGrayedOut
{
	if (isGrayedOut)
	{
		if (!self.maskView)
		{
			self.maskView = [[UIView alloc] initWithFrame:self.contentView.frame];
			self.maskView.backgroundColor = [UIColor colorFromStyle:@"white"];
			self.maskView.alpha = 0.8f;
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


+ (void)setTextColor:(UITextField *)textField editable:(BOOL)editable
{
	[textField setTextColor:(editable ? [UIColor colorFromStyle:textField.fontStyle] : [UIColor colorFromStyle:@"CoreFont"])];
}

-(NSCharacterSet *)englishCharacterExclusionSet
{
    if (!_englishCharacterExclusionSet)
    {
        _englishCharacterExclusionSet = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ."] invertedSet];
    }
    
    return _englishCharacterExclusionSet;
}

-(NSString*)stripAccentsFromString:(NSString*)source
{
    NSString *modified = [source decomposedStringWithCanonicalMapping];
    modified = [[modified componentsSeparatedByCharactersInSet:self.englishCharacterExclusionSet] componentsJoinedByString:@""];
    return modified;
}

@end
