//
//  TextCell.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextCell.h"
#import "UIColor+Theme.h"

NSString *const TWTextCellIdentifier = @"TextCell";

@implementation TextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.textLabel setTextColor:[UIColor disabledEntryTextColor]];
    [self.detailTextLabel setTextColor:[UIColor disabledEntryTextColor]];
}

- (void)configureWithTitle:(NSString *)title text:(NSString *)text {
    [self.textLabel setText:title];
    [self.detailTextLabel setText:text];
}

@end
