//
//  CountrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

@class Country;
@class CountrySelectionCell;

extern NSString *const TWCountrySelectionCellIdentifier;


typedef void (^CountrySelectionBlock)(NSString *countryName);

@protocol CountrySelectionCellDelegate <NSObject>

- (Country *)getCountryByCode:(NSString *)code;
- (Country *)getCountryByName:(NSString *)name;

@optional
-(void)countrySelectionCell:(CountrySelectionCell*)cell selectedCountry:(Country*)countryCode;

@end

@interface CountrySelectionCell : TextEntryCell

@property (nonatomic, weak) id<CountrySelectionCellDelegate> countrySelectionDelegate;
@property (nonatomic, copy) CountrySelectionBlock selectionHandler;

- (void)setTwoLetterCountryCode:(NSString *)code;

@end
