//
//  RecipientCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlainRecipient;

@interface RecipientCell : UITableViewCell

- (void)configureWithRecipient:(PlainRecipient *)recipient;

@end
