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

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
{
	[super configureWithTitle:title value:value];
	[self.entryField addTarget:self action:@selector(editingEnded) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setValue:(NSString *)value
{
    [self setValueFromCode:value];
}

- (NSString *)value
{
	//if we have selected country, set selected value
	//if we do not have selected country, but user has typed something, set to invalid
	//if we do not have selected country and user hasn't typed anything, leave empty
    return self.selectedCountry ? self.selectedCountry.iso3Code :
		([self.entryField.text hasValue] ? @"invalid" : @"");
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

- (void)editingEnded
{
	if ([self.entryField.text hasValue])
	{
		//this will be either set to a correct country if user typed the name of the countr
		//or nil, if value is incorrect
		//if user selected country form the list then that selection will be tone after this
		self.selectedCountry = [self.countrySelectionDelegate getCountryByName:self.entryField.text];
	}
	else
	{
		self.selectedCountry = nil;
	}
}

@end
