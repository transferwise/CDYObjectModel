//
//  CurrencySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Currency;

extern NSString *const TWCurrencySelectionCellIdentifier;

typedef void (^TRWCurrencySelectionBlock)(Currency *currency);

@interface CurrencySelectionCell : UITableViewCell

@property (nonatomic, copy) TRWCurrencySelectionBlock selectionHandler;

- (void)setAllCurrencies:(NSArray *)currencies;

@end
