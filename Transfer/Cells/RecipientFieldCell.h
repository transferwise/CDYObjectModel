//
//  RecipientFieldCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEntryCell.h"

@class RecipientTypeField;

extern NSString *const TWRecipientFieldCellIdentifier;

@interface RecipientFieldCell : TextEntryCell

- (void)setFieldType:(RecipientTypeField *)field;

@end
