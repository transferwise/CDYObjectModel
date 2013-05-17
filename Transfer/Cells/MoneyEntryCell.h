//
//  MoneyEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Currency;

extern NSString *const TWMoneyEntryCellIdentifier;

typedef void (^CurrencyChangBlock)(Currency *currency);

@interface MoneyEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *moneyField;
@property (nonatomic, strong) NSArray *presentedCurrencies;
@property (nonatomic, strong) CurrencyChangBlock currencyChangedHandler;

- (void)setTitle:(NSString *)title;
- (void)setAmount:(NSString *)amount currency:(Currency *)currency;
- (NSString *)amount;
- (Currency *)currency;
- (void)setOnlyPresentedCurrency:(NSString *)currencyCode;

@end
