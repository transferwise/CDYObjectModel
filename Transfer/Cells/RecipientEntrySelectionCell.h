//
//  RecipientEntrySelectionCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/10/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"

@class Recipient;

extern NSString *const TRWRecipientEntrySelectionCellIdentifier;

typedef void (^RecipientSelectionBlock)(Recipient *recipient);

@interface RecipientEntrySelectionCell : TextEntryCell


@property (nonatomic, copy) RecipientSelectionBlock selectionHandler;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

@end
