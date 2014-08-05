//
//  EmailEntryCell.h
//  Transfer
//
//  Created by Juhan Hion on 05.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

extern NSString *const TWEmailEntryCellIdentifier;

@protocol EmailEntryCellDelegate <NSObject>


@end

@interface EmailEntryCell : TextEntryCell

@property (nonatomic, weak) id<EmailEntryCellDelegate> delegate;

@end
