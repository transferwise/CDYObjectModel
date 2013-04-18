//
//  MoneyEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TWMoneyEntryCellIdentifier;

@interface MoneyEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *moneyField;

- (void)setTitle:(NSString *)title;
- (void)setAmount:(NSString *)amount currency:(NSString *)currency;
- (NSString *)amount;
- (NSString *)currency;

@end
