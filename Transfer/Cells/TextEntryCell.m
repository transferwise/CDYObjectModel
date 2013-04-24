//
//  TextEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

NSString *const TWTextEntryCellIdentifier = @"TextEntryCell";

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *entryField;

@end

@implementation TextEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    [self.titleLabel setText:title];
    [self.entryField setText:value];

    CGRect titleFrame = self.titleLabel.frame;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(titleFrame))];
    CGFloat widthChange = titleSize.width - CGRectGetWidth(titleFrame);
    titleFrame.size.width += widthChange;
    [self.titleLabel setFrame:titleFrame];

    CGRect entryFrame = self.entryField.frame;
    entryFrame.origin.x += widthChange;
    entryFrame.size.width -= widthChange;
    [self.entryField setFrame:entryFrame];
}

- (NSString *)value {
    return [self.entryField text];
}

- (void)setValue:(NSString *)value {
    [self.entryField setText:value];
}

@end
