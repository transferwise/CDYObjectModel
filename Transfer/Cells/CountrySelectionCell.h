//
//  CountrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

extern NSString *const TWCountrySelectionCellIdentifier;

@class CountrySelectionCell;
@class Country;

@protocol CountrySelectionCellDelegate <NSObject>

@optional
-(void)countrySelectionCell:(CountrySelectionCell*)cell selectedCountry:(Country*)countryCode;

@end

@interface CountrySelectionCell : TextEntryCell

@property (nonatomic, strong) NSFetchedResultsController *allCountries;
@property (nonatomic, weak) id<CountrySelectionCellDelegate>delegate;

- (void)setTwoLetterCountryCode:(NSString *)code;

@end
