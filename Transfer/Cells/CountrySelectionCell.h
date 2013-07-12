//
//  CountrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

extern NSString *const TWCountrySelectionCellIdentifier;

@interface CountrySelectionCell : TextEntryCell

@property (nonatomic, strong) NSFetchedResultsController *allCountries;

- (void)setTwoLetterCountryCode:(NSString *)code;

@end
