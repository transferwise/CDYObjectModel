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
#import "UIColor+MOMStyle.h"
#import "UIResponder+FirstResponder.h"

NSString *const TWDateEntryCellIdentifier = @"DateEntryCell";

#define DAY_MONTH_MAX_LENGTH	2
#define YEAR_MAX_LENGTH			4

@interface DateEntryCell ()

@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *dayTextField;
@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *monthTextField;
@property (strong, nonatomic) IBOutlet StyledPlaceholderTextField *yearTextField;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@property (strong, nonatomic) UIView* daySeparator;
@property (strong, nonatomic) UIView* monthSeparator;
@property (strong, nonatomic) UIView* yearSeparator;

@property (nonatomic, copy) TRWActionBlock doneButtonAction;

@property (nonatomic) BOOL separatorsAdded;

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
	[self configureFields];
}

- (void)configureFields
{
	self.dayTextField.delegate = self;
	self.dayTextField.keyboardType = UIKeyboardTypeNumberPad;
	[self.dayTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
	self.monthTextField.delegate = self;
	self.monthTextField.keyboardType = UIKeyboardTypeNumberPad;
	[self.monthTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
	self.yearTextField.delegate = self;
	self.yearTextField.keyboardType = UIKeyboardTypeNumberPad;
	[self.yearTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
}

- (void)configureLabels
{
	MOMBasicStyle* placeholderStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@{17,20}.Greygory"];
	
	self.dayTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	self.dayTextField.placeholderStyle = placeholderStyle;
	[self.dayTextField configureWithTitle:NSLocalizedString(@"profile.dob.day", nil) value:@""];
	
	self.monthTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	self.monthTextField.placeholderStyle = placeholderStyle;
	[self.monthTextField configureWithTitle:NSLocalizedString(@"profile.dob.month", nil) value:@""];
	
	self.yearTextField.fontStyle = @"heavy.@{17,20}.DarkFont";
	self.yearTextField.placeholderStyle = placeholderStyle;
	[self.yearTextField configureWithTitle:NSLocalizedString(@"profile.dob.year", nil) value:@""];
}

- (void)setSeparators
{
	if (!self.separatorsAdded)
	{
		//really loving the random constants here :(
		self.daySeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.dayTextField.frame.origin.x - 20,
																			   self.contentView.frame.origin.y,
																			   self.dayTextField.frame.size.width + 10,
																			   self.contentView.frame.size.height)
													  showFullWidth:NO];
		[self.contentView addSubview:self.daySeparator];
		self.monthSeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.monthTextField.frame.origin.x - 20,
																				 self.contentView.frame.origin.y,
																				 self.monthTextField.frame.size.width + 10,
																				 self.contentView.frame.size.height)
														showFullWidth:NO];
		[self.contentView addSubview:self.monthSeparator];
		self.yearSeparator = [UIView getSeparatorLineWithParentFrame:CGRectMake(self.yearTextField.frame.origin.x - 20,
																				self.contentView.frame.origin.y,
																				self.contentView.frame.size.width - self.yearTextField.frame.origin.x +20,
																				self.contentView.frame.size.height)
													   showFullWidth:NO];
		[self.contentView addSubview:self.yearSeparator];
		
		self.separatorsAdded = YES;
	}
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value
{
	[self setDateString:value];
	self.headerLabel.text = title;
}

- (void)changeHeaderColor
{
	if ([self.dayTextField.text hasValue]
		|| [self.monthTextField.text hasValue]
		|| [self.yearTextField.text hasValue])
	{
		[self.headerLabel setTextColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
	}
	else
	{
		[self.headerLabel setTextColor:[UIColor colorFromStyle:@"GreyGory"]];
	}
}

#pragma mark - Editable
- (BOOL)editable
{
	return [self.dayTextField isEnabled]
		&& [self.monthTextField isEnabled]
		&& [self.yearTextField isEnabled];
}

- (void)setEditable:(BOOL)editable
{
	self.dayTextField.enabled = editable;
	[TextEntryCell setTextColor:self.dayTextField editable:editable];
	self.monthTextField.enabled = editable;
	[TextEntryCell setTextColor:self.monthTextField editable:editable];
	self.yearTextField.enabled = editable;
	[TextEntryCell setTextColor:self.yearTextField editable:editable];
}

#pragma mark - Value Getters/Setters
- (void)setValue:(NSString *)value
{
	if ([value hasValue])
	{
		NSDate *date = [[DateEntryCell rawDateFormatter] dateFromString:value];
		[self setDateValue:date];
	}
	else
	{
		self.dayTextField.text = @"";
		self.monthTextField.text = @"";
		self.yearTextField.text = @"";
	}	
}

- (void)setDateValue:(NSDate *)date
{
    if (!date)
	{
        return;
    }
	
	[self presentDate:date];
}

- (NSString *)value
{
	if (![self.dayTextField.text hasValue]
		&& ![self.monthTextField.text hasValue]
		&& ![self.yearTextField.text hasValue])
	{
		return @"";
	}
	else
	{
		NSString* unknownValue = NSLocalizedString(@"unknown.value", nil);
		
		NSString* day = [self.dayTextField.text hasValue] ? self.dayTextField.text : unknownValue;
		NSString* month = [self.monthTextField.text hasValue] ? self.monthTextField.text : unknownValue;
		NSString* year = [self.yearTextField.text hasValue] ? self.yearTextField.text : unknownValue;
		
		return [NSString stringWithFormat:@"%@-%@-%@", year, month, day];
	}
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
		[self presentDate:convertedDate];
	}
}

- (void)presentDate:(NSDate *)date
{
	NSDateComponents* components = [DateEntryCell getComponents:date];
	
	self.dayTextField.text = [DateEntryCell paddedString:[components day]];
	self.monthTextField.text = [DateEntryCell paddedString:[components month]];
	self.yearTextField.text = [NSString stringWithFormat:@"%i", [components year]];
}

+ (NSString *)paddedString:(NSInteger)component
{
	return [NSString stringWithFormat:(component < 10 ? @"0%i" : @"%i"), component];
}

#pragma mark - Validation
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSUInteger newLength = [textField.text length] + [string length] - range.length;
	
	return [self validateLength:newLength textField:textField]
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self changeHeaderColor];
}

#pragma mark - Moving between cells
- (void)activate
{
	if (!self.editable)
	{
		return;
	}
	
	[self.dayTextField becomeFirstResponder];
	[self changeHeaderColor];
}

- (BOOL)shouldNavigateAway
{
	return self.selectedTextField.tag == kYearField;
}

- (void)textChanged:(UITextField *)textField
{
	[self navigateToNext:textField withValidation:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self navigateToNext:textField withValidation:NO];
	return YES;
}

- (void)navigateToNext:(UITextField *)textField withValidation:(BOOL)withValidation
{
	[self changeHeaderColor];
	if (textField.tag == kDayField)
	{
		if (!withValidation || textField.text.length == DAY_MONTH_MAX_LENGTH)
		{
			[self.monthTextField becomeFirstResponder];
		}
	}
	else if (textField.tag == kMonthField)
	{
		if (!withValidation || textField.text.length == DAY_MONTH_MAX_LENGTH)
		{
			[self.yearTextField becomeFirstResponder];
		}
	}
	else if (textField.tag == kYearField)
	{
		if (!withValidation || textField.text.length == YEAR_MAX_LENGTH)
		{
			[textField resignFirstResponder];
			[self.headerLabel setTextColor:[UIColor colorFromStyle:@"CoreFont"]];
			[self navigateAway];
		}
	}
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

@end
