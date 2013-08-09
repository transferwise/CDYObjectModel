//
//  DateEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DateEntryCell.h"

NSString *const TWDateEntryCellIdentifier = @"DateEntryCell";

@interface DateEntryCell ()

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation DateEntryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [self setDatePicker:picker];
    [self.entryField setInputView:picker];
    [picker setMaximumDate:[NSDate date]];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [picker addTarget:self action:@selector(pickerDateChanged) forControlEvents:UIControlEventValueChanged];

    [self addDoneButton];
}

- (void)setValue:(NSString *)value {
    NSDate *date = [[DateEntryCell rawDateFormatter] dateFromString:value];
    [self setDateValue:date];
}

- (void)setDateValue:(NSDate *)date {
    [self presentDate:date];

    if (!date) {
        return;
    }
    [self.datePicker setDate:date];
}

- (NSString *)value {
    return [[DateEntryCell rawDateFormatter] stringFromDate:self.datePicker.date];
}


- (void)pickerDateChanged {
    [self markTouched];
    [self presentDate:self.datePicker.date];
}

- (void)presentDate:(NSDate *)date {
    [self.entryField setText:[[DateEntryCell prettyDateFormatter] stringFromDate:date]];
}

static NSDateFormatter *__rawDateFormatter;
+ (NSDateFormatter *)rawDateFormatter {
    if (!__rawDateFormatter) {
        __rawDateFormatter = [[NSDateFormatter alloc] init];
        [__rawDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }

    return __rawDateFormatter;
}

static NSDateFormatter *__prettyDateFormatter;
+ (NSDateFormatter *)prettyDateFormatter {
    if (!__prettyDateFormatter) {
        __prettyDateFormatter = [[NSDateFormatter alloc] init];
        [__prettyDateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [__prettyDateFormatter setDateStyle:NSDateFormatterShortStyle];
    }

    return __prettyDateFormatter;
}

@end
