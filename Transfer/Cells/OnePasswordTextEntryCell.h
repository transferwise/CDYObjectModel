//
//  TextEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

@import UIKit;
#import "TextEntryCell.h"
#import "Constants.h"
#import "SeparatorViewCell.h"

extern NSString *const TWOnePasswordTextEntryCellIdentifier;

// Extend the protocol to include the 1Password button
@protocol OnePasswordTextEntryCellDelegate <TextEntryCellDelegate>

@optional

- (IBAction) userTouchedOnePasswordButton: (UIButton *) button;

@end

@interface OnePasswordTextEntryCell : TextEntryCell

@property (nonatomic, weak) id<OnePasswordTextEntryCellDelegate> delegate;

@end


