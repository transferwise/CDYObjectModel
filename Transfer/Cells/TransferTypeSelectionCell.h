//
//  TransferTypeSelectionCell.h
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipientType;

typedef void (^RecipientTypeChangedInSelectionCellBlock)(RecipientType *type);

extern NSString *const TWTypeSelectionCellIdentifier;

@interface TransferTypeSelectionCell : UITableViewCell

@property (nonatomic, copy) RecipientTypeChangedInSelectionCellBlock selectionChangeHandler;

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes;
- (void)changeSelectedTypeTo:(RecipientType *)tappedOn;

@end
