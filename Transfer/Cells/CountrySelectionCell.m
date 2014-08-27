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

@interface CountrySelectionCell ()

@property (nonatomic, strong) Country *selectedCountry;

@end

@implementation CountrySelectionCell

- (void)setValue:(NSString *)value
{
    [self setValueFromCode:value];
}

- (NSString *)value
{
    return self.selectedCountry ? self.selectedCountry.iso3Code : @"";
}

- (void)setTwoLetterCountryCode:(NSString *)code
{
	[self setValueFromCode:code];
}

- (void)setValueFromCode:(NSString *)value
{
	Country *selected = [self.countrySelectionDelegate getCountryByCode:value];
	
    self.selectedCountry = selected;
    [self.entryField setText:selected.name];
}

@end
