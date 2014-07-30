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
//    Country *selected = [self countryByCode:value];
//    [self setSelectedCountry:selected];
//    if (!selected)
//	{
//        return;
//    }
//
//    [self.entryField setText:selected.name];
//    NSInteger countryIndex = [self.allCountries indexPathForObject:selected].row;
//    [self.countryPicker selectRow:countryIndex inComponent:0 animated:NO];
}

- (NSString *)value
{
    return self.selectedCountry ? self.selectedCountry.iso3Code : @"";
}

//- (Country *)countryByCode:(NSString *)code
//{
//    if (![code hasValue])
//	{
//        //TODO jaanus: use country code from locale?
//        return nil;
//    }
//
//    for (Country *country in self.allCountries.fetchedObjects)
//	{
//        if ([country.iso3Code isEqualToString:code])
//		{
//            return country;
//        }
//    }
//
//    return nil;
//}

- (void)setTwoLetterCountryCode:(NSString *)code {
//    Country *country = nil;
//    for (Country *checked in self.allCountries.fetchedObjects)
//	{
//        if (![[checked.iso2Code lowercaseString] isEqualToString:code])
//		{
//            continue;
//        }
//
//        country = checked;
//        break;
//    }
//
//    if (!country)
//	{
//        return;
//    }
//
//    self.selectedCountry = country;
//    self.entryField.text = country.name;
}

@end
