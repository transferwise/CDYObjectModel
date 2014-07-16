//
//  RecipientCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeToCancelCell.h"

@class Recipient;

@interface RecipientCell : SwipeToCancelCell

- (void)configureWithRecipient:(Recipient *)recipient;

@end
