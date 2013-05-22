//
//  CountrySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CountrySelectionCell.h"
#import "Country.h"
#import "NSString+Validation.h"

NSString *const TWCountrySelectionCellIdentifier = @"CountrySelectionCell";

@interface CountrySelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *countryPicker;
@property (nonatomic, strong) Country *selectedCountry;

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

    //TODO jaanus: copy/paste from money cell
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //TODO jaanus: button title based on entry return key type
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[flexible, done]];
    [self.entryField setInputAccessoryView:toolbar];
}

- (void)setValue:(NSString *)value {
    Country *selected = [self countryByCode:value];
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


- (Country *)countryByCode:(NSString *)code {
    if (![code hasValue]) {
        //TODO jaanus: use country code from locale?
        return nil;
    }

    for (Country *country in self.allCountries) {
        if ([country.isoCode3 isEqualToString:code]) {
            return country;
        }
    }

    return nil;
}


- (void)donePressed {
    [self.entryField.delegate textFieldShouldReturn:self.entryField];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allCountries count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Country *country = self.allCountries[(NSUInteger) row];
    return country.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Country *selected = self.allCountries[(NSUInteger) row];
    [self setSelectedCountry:selected];
    [self.entryField setText:selected.name];
}


- (void)setTwoLetterCountryCode:(NSString *)code {
    Country *country = nil;
    for (Country *checked in self.allCountries) {
        if (![checked.isoCode2 isEqualToString:code]) {
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
