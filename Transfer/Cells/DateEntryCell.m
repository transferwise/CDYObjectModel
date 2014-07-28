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
#import "UIView+SeparatorLine.h"

NSString *const TWDateEntryCellIdentifier = @"DateEntryCell";

@interface DateEntryCell ()

@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *monthTextField;
@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *yearTextField;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) UIView* daySeparator;
@property (strong, nonatomic) UIView* monthSeparator;
@property (strong, nonatomic) UIView* yearSeparator;

@end

@implementation DateEntryCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self commonSetup];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setSeparators];
}

- (void)commonSetup
{
	//remove default separator line
	self.separatorLine = [[UIView alloc] init];
	[self configureLabels];
}

- (void)configureLabels
{
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
}

- (void)setSeparators
{
	//really loving the random constants here :(
	self.daySeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.entryField.frame.origin.x - 20,
																		   self.contentView.frame.origin.y,
																		   self.entryField.frame.size.width + 10,
																		   self.contentView.frame.size.height)];
	[self.contentView addSubview:self.daySeparator];
	self.monthSeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.monthTextField.frame.origin.x - 20,
																			 self.contentView.frame.origin.y,
																			 self.monthTextField.frame.size.width + 10,
																			 self.contentView.frame.size.height)];
	[self.contentView addSubview:self.monthSeparator];
	self.yearSeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.yearTextField.frame.origin.x - 20,
																			self.contentView.frame.origin.y,
																			self.contentView.frame.size.width - self.yearTextField.frame.origin.x +20,
																			self.contentView.frame.size.height)];
	[self.contentView addSubview:self.yearSeparator];
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	[self setDateString:value];
	self.headerLabel.text = title;
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
	
	NSDate* convertedDate = [[DateEntryCell rawDateFormatter] dateFromString:date];
	
	if(convertedDate)
	{
		NSDateComponents* components = [DateEntryCell getComponents:convertedDate];
		
		self.entryField.text = [NSString stringWithFormat:@"%i", [components day]];
		self.monthTextField.text = [NSString stringWithFormat:@"%i", [components month]];
		self.yearTextField.text = [NSString stringWithFormat:@"%i", [components year]];
	}
}

- (void)presentDate:(NSDate *)date
{
	//TODO: set date parts to text fields
    [self.entryField setText:[[DateEntryCell prettyDateFormatter] stringFromDate:date]];
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

+ (NSDateComponents *)getComponents:(NSDate *)date
{
	return [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
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
