//
//  RecipientFieldCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientFieldCell.h"
#import "RecipientTypeField.h"
#import "NSString+Validation.h"
#import "NSString+Presentation.h"

NSString *const TWRecipientFieldCellIdentifier = @"TWRecipientFieldCellIdentifier";

@interface RecipientFieldCell ()

@property (nonatomic, strong) RecipientTypeField *type;

@end

@implementation RecipientFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (void)setFieldType:(RecipientTypeField *)field
{
    [self setType:field];
	self.maxValueLength = [self.type maxLengthValue];
    [self configureWithTitle:field.title value:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *pattern = self.type.presentationPattern;

    if (![pattern hasValue] && self.maxValueLength == 0)
	{
        return YES;
    }

    NSString *modified = [self.entryField.text stringByReplacingCharactersInRange:range withString:string];

    if ([pattern hasValue] && [modified length] > [pattern length])
	{
        return NO;
    }

    if (self.maxValueLength > 0 && [modified length] > self.maxValueLength)
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

    [self.entryField setText:modified];

    return NO;
}

@end
