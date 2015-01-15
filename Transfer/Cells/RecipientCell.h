//
//  RecipientCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeActionCell.h"

@class Recipient;

@interface RecipientCell : SwipeActionCell

@property (strong, nonatomic) IBOutlet UILabel *sendLabel;

- (void)configureWithRecipient:(Recipient *)recipient
		 willShowCancelBlock:(TRWActionBlock)willShowCancelBlock
		  didShowCancelBlock:(TRWActionBlock)didShowCancelBlock
		  didHideCancelBlock:(TRWActionBlock)didHideCancelBlock
		   cancelTappedBlock:(TRWActionBlock)cancelTappedBlock;

@end
