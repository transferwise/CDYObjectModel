//
//  CountrySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CountrySelectionCell.h"
#import "PlainCountry.h"
#import "NSString+Validation.h"

NSString *const TWCountrySelectionCellIdentifier = @"CountrySelectionCell";

@interface CountrySelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *countryPicker;
@property (nonatomic, strong) PlainCountry *selectedCountry;

@end

@implementation CountrySelectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [self setCountryPicker:pickerView];
    [self.entryField setInputView:pickerView];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];

    [self addDoneButton];
}

- (void)setValue:(NSString *)value {
    PlainCountry *selected = [self countryByCode:value];
    [self setSelectedCountry:selected];
    if (!selected) {
        return;
    }

    [self.entryField setText:selected.name];
    NSUInteger countryIndex = [self.allCountries indexOfObject:selected];
    [self.countryPicker selectRow:countryIndex inComponent:0 animated:NO];
}

- (NSString *)value {
    return self.selectedCountry ? self.selectedCountry.isoCode3 : @"";
}


- (PlainCountry *)countryByCode:(NSString *)code {
    if (![code hasValue]) {
        //TODO jaanus: use country code from locale?
        return nil;
    }

    for (PlainCountry *country in self.allCountries) {
        if ([country.isoCode3 isEqualToString:code]) {
            return country;
        }
    }

    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allCountries count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PlainCountry *country = self.allCountries[(NSUInteger) row];
    return country.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    PlainCountry *selected = self.allCountries[(NSUInteger) row];
    [self setSelectedCountry:selected];
    [self.entryField setText:selected.name];
}


- (void)setTwoLetterCountryCode:(NSString *)code {
    PlainCountry *country = nil;
    for (PlainCountry *checked in self.allCountries) {
        if (![[checked.isoCode2 lowercaseString] isEqualToString:code]) {
            continue;
        }

        country = checked;
        break;
    }

    if (!country) {
        return;
    }

    self.selectedCountry = country;
    self.entryField.text = country.name;
}

@end
