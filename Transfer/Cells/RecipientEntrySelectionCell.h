//
//  RecipientEntrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/10/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"

@class PlainRecipient;

extern NSString *const TRWRecipientEntrySelectionCellIdentifier;

typedef void (^RecipientSelectionBlock)(PlainRecipient *recipient);

@interface RecipientEntrySelectionCell : TextEntryCell

@property (nonatomic, strong) NSArray *autoCompleteRecipients;
@property (nonatomic, copy) RecipientSelectionBlock selectionHandler;

@end
