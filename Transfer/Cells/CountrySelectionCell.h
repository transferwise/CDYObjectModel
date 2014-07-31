//
//  CountrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

@class Country;

extern NSString *const TWCountrySelectionCellIdentifier;

typedef void (^CountrySelectionBlock)(Country *recipient);

@interface CountrySelectionCell : TextEntryCell

@property (nonatomic, copy) CountrySelectionBlock selectionHandler;

- (void)setTwoLetterCountryCode:(NSString *)code;

@end
