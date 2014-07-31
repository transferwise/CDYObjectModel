//
//  ZipCityCell.h
//  Transfer
//
//  Created by Juhan Hion on 31.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleEntryCell.h"

extern NSString *const TWZipCityCellIdentifier;

@interface DoubleEntryCell : MultipleEntryCell

@property (nonatomic, strong) NSString* secondValue;

- (void)configureWithTitle:(NSString *)title
					 value:(NSString *)value
				 secondTitle:(NSString *)secondTitle
				 secondValue:(NSString *)secondValue;

- (void)setSecondEditable:(BOOL)value;
- (void)setAutoCapitalization:(UITextAutocapitalizationType)capitalizationType;

@end
