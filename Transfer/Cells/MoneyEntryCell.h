//
//  MoneyEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"

@class Currency;

extern NSString *const TWMoneyEntryCellIdentifier;

typedef void (^CurrencyChangBlock)(Currency *currency);

@interface MoneyEntryCell : TextEntryCell

@property (nonatomic, strong, readonly) UITextField *moneyField;
@property (nonatomic, strong) CurrencyChangBlock currencyChangedHandler;
@property (nonatomic, strong) NSFetchedResultsController *currencies;
@property (nonatomic, weak) UIViewController* hostForCurrencySelector;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic) BOOL leftSeparatorHidden;
@property (nonatomic) BOOL currenciesLoaded;
@property (nonatomic, strong) Currency *suggestedStartCurrency;


- (void)setTitle:(NSString *)title;
- (void)setAmount:(NSString *)amount currency:(Currency *)currency;
- (NSString *)amount;
- (Currency *)currency;
- (void)setForcedCurrency:(Currency *)currency;
- (void)setMoneyValue:(NSString *)moneyString;
- (void)initializeSelectorBackground;

@end
