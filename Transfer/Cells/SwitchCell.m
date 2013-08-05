//
//  SwitchCell.m
//  Transfer
//
//  Created by Henri Mägi on 05.08.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

NSString *const TWSwitchCellIdentifier = @"TWSwitchCell";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
