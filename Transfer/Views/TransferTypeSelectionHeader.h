//
//  TransferTypeSelectionCell.h
//  Transfer
//
//  Created by Henri Mägi on 17.06.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryDefaultHeader.h"

@class RecipientType;

typedef void (^RecipientTypeChangedInSelectionCellBlock)(RecipientType *type, NSArray *allTypes);

extern NSString *const TWTypeSelectionCellIdentifier;

@interface TransferTypeSelectionHeader : DataEntryDefaultHeader

@property (nonatomic, copy) RecipientTypeChangedInSelectionCellBlock selectionChangeHandler;

- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes;

@end
