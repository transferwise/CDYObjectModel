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
#import "UITextField+ModifiedText.h"

NSString *const TWDateEntryCellIdentifier = @"DateEntryCell";

#define DAY_MONTH_MAX_LENGTH	2
#define YEAR_MAX_LENGTH			4

@interface DateEntryCell ()

@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *monthTextField;
@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *yearTextField;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) UIView* daySeparator;
@property (strong, nonatomic) UIView* monthSeparator;
@property (strong, nonatomic) UIView* yearSeparator;

@end

@implementation DateEntryCell

NSInteger const kDayField = 1;
NSInteger const kMonthField = 2;
NSInteger const kYearField = 3;

#pragma mark - Init and Configuration
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
	
	self.entryField.delegate = self;
	self.monthTextField.delegate = self;
	self.yearTextField.delegate = self;
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

#pragma mark - Value Getters/Setters
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

#pragma mark - Validation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
	return [self validateLength:newLength textField:textField]
		&& [self validateContent:string range:range textField:textField]
		&& [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)validateLength:(NSUInteger)newLength textField:(UITextField *)textField
{
	if (textField.tag == kDayField || textField.tag == kMonthField)
	{
		return newLength <= DAY_MONTH_MAX_LENGTH;
	}
	else if (textField.tag == kYearField)
	{
		return newLength <= YEAR_MAX_LENGTH;
	}
	
	return NO;
}

- (BOOL)validateContent:(NSString *)text range:(NSRange)range textField:(UITextField *)textField
{
	NSString* modified = [textField modifiedText:range newText:text];
	
	//allow to delete everything inserted
	if (self.valueModified && [modified isEqualToString:@""])
	{
		return YES;
	}
	
	//cast to int, if this fails then there is no need to go further
	NSInteger value = [modified integerValue];
	
	if (value < 1)
	{
		return NO;
	}
	
	if (textField.tag == kDayField)
	{
		return value <= 31;
	}
	else if (textField.tag == kMonthField)
	{
		return value <= 12;
	}
	else if (textField.tag == kMonthField)
	{
		NSUInteger year = [[DateEntryCell getComponents:[NSDate date]] year];
		//arbitrary values, maybe 10-year olds will be using us very soon.
		//maybe 100-year olds ar already using us on iOS.
		return value >= year - 100 && value <= year - 10;
	}
	
	return NO;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == kDayField)
	{
		[self.monthTextField becomeFirstResponder];
	}
	else if(textField.tag == kMonthField)
	{
		[self.yearTextField becomeFirstResponder];
	}
	
	return YES;
}

#pragma mark - Date helpers
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
