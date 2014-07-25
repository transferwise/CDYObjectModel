//
//  DateEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DateEntryCell.h"
#import "NSString+Validation.h"
#import "MOMBasicStyle.h"
#import "MOMStyleFactory.h"
#import "StyledPlaceholderTextField.h"
#import "UIView+MOMStyle.h"

NSString *const TWDateEntryCellIdentifier = @"DateEntryCell";

@interface DateEntryCell ()

@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *monthTextField;
@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *yearTextField;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation DateEntryCell

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	[self setDateString:value];
	self.headerLabel.text = NSLocalizedString(@"personal.profile.date.of.birth.label", nil);
	
	MOMBasicStyle* placeholderStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@{17,20}.Greygory"];
	StyledPlaceholderTextField* dayTextField = (StyledPlaceholderTextField *)self.entryField;
	
	dayTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	dayTextField.placeholderStyle = placeholderStyle;
	[dayTextField configureWithTitle:NSLocalizedString(@"profile.dob.day", nil) value:@""];
	
	self.monthTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	self.monthTextField.placeholderStyle = placeholderStyle;
	[self.monthTextField configureWithTitle:NSLocalizedString(@"profile.dob.month", nil) value:@""];
	
	self.yearTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	self.yearTextField.placeholderStyle = placeholderStyle;
	[self.yearTextField configureWithTitle:NSLocalizedString(@"profile.dob.year", nil) value:@""];
	//TODO: set title
}

- (void)setValue:(NSString *)value
{
    NSDate *date = [[DateEntryCell rawDateFormatter] dateFromString:value];
    [self setDateValue:date];
}

- (void)setDateValue:(NSDate *)date
{
    [self presentDate:date];

    if (!date)
	{
        return;
    }
}

- (NSString *)value
{
	if (![self.entryField.text hasValue])
	{
		return @"";
	}

    return [self getDateString];
}

- (NSString *)getDateString
{
	//TODO: get date from fields, validate, that it actually is date
	return @"";
}

- (void)setDateString:(NSString *)date
{
	if ([date isEqualToString:@""])
	{
		return;
	}
	
	//TODO: get date from string, validate, set to fields
}

- (void)presentDate:(NSDate *)date
{
	//TODO: set date parts to text fields
    [self.entryField setText:[[DateEntryCell prettyDateFormatter] stringFromDate:date]];
}

static NSDateFormatter *__rawDateFormatter;
+ (NSDateFormatter *)rawDateFormatter
{
    if (!__rawDateFormatter)
	{
        __rawDateFormatter = [[NSDateFormatter alloc] init];
        [__rawDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    return __rawDateFormatter;
}

static NSDateFormatter *__prettyDateFormatter;
+ (NSDateFormatter *)prettyDateFormatter
{
    if (!__prettyDateFormatter)
	{
        __prettyDateFormatter = [[NSDateFormatter alloc] init];
        [__prettyDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [__prettyDateFormatter setDateStyle:NSDateFormatterShortStyle];
    }

    return __prettyDateFormatter;
}

@end
