//
//  TextCell.m
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextCell.h"

NSString *const TWTextCellIdentifier = @"TextCell";

@implementation TextCell

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

- (void)configureWithTitle:(NSString *)title text:(NSString *)text {
    [self.titleLabel setText:title];
    [self.textLabel setText:text];
    
    CGRect titleFrame = self.titleLabel.frame;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(titleFrame))];
    CGFloat widthChange = titleSize.width - CGRectGetWidth(titleFrame);
    titleFrame.size.width += widthChange;
    [self.titleLabel setFrame:titleFrame];
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x += widthChange;
    textFrame.size.width -= widthChange;
    [self.textLabel setFrame:textFrame];
}

@end
