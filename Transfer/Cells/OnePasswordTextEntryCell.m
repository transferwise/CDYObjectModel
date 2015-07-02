//
//  TextEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "AuthenticationHelper.h"
#import "OnePasswordTextEntryCell.h"

NSString *const TWOnePasswordTextEntryCellIdentifier = @"OnePasswordTextEntryCell";

@interface OnePasswordTextEntryCell ()

@property (nonatomic, weak) IBOutlet UIButton *onePasswordButton;

@end

@implementation OnePasswordTextEntryCell

@dynamic delegate;

/**
 *  When this cell is first created, check to see if 1Password is installed on the user's device,
 *  and only then display the button
 */

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [self.onePasswordButton setHidden: ![AuthenticationHelper onePasswordIsAvaliable]];
}

/**
 *  The user touched the 1Password button, so call our delegate directly
 *
 *  @param button button
 */

- (IBAction) userTouchedOnePasswordButton: (UIButton *) button
{
    // Simply pass directly on to our delegate
    if ([self.delegate respondsToSelector: @selector(userTouchedOnePasswordButton:)])
    {
        [self.delegate userTouchedOnePasswordButton: button];
    }
}

@end
