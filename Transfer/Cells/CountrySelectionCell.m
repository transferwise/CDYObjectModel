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

@interface CountrySelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate>

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

- (void)dealloc {
    [self.allCountries setDelegate:nil];
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

- (void)setAllCountries:(NSFetchedResultsController *)allCountries {
    [_allCountries setDelegate:nil];
    _allCountries = allCountries;
    [_allCountries setDelegate:self];
}


- (void)setValue:(NSString *)value {
    Country *selected = [self countryByCode:value];
    [self setSelectedCountry:selected];
    if (!selected) {
        return;
    }

    [self.entryField setText:selected.name];
    NSInteger countryIndex = [self.allCountries indexPathForObject:selected].row;
    [self.countryPicker selectRow:countryIndex inComponent:0 animated:NO];
}

- (NSString *)value {
    return self.selectedCountry ? self.selectedCountry.iso3Code : @"";
}


- (Country *)countryByCode:(NSString *)code {
    if (![code hasValue]) {
        //TODO jaanus: use country code from locale?
        return nil;
    }

    for (Country *country in self.allCountries.fetchedObjects) {
        if ([country.iso3Code isEqualToString:code]) {
            return country;
        }
    }

    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allCountries.fetchedObjects count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Country *country = [self.allCountries objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return country.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Country *selected = [self.allCountries objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [self setSelectedCountry:selected];
    [self.entryField setText:selected.name];
    if([self.delegate respondsToSelector:@selector(countrySelectionCell:selectedCountry:)])
    {
        [self.delegate countrySelectionCell:self selectedCountry:selected];
    }
}


- (void)setTwoLetterCountryCode:(NSString *)code {
    Country *country = nil;
    for (Country *checked in self.allCountries.fetchedObjects) {
        if (![[checked.iso2Code lowercaseString] isEqualToString:code]) {
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.countryPicker reloadAllComponents];
}

@end
