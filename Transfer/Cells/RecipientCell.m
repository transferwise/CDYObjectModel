//
//  RecipientCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientCell.h"
#import "Recipient.h"
#import "UIColor+Theme.h"

@interface RecipientCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end

@implementation RecipientCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.nameLabel setTextColor:[UIColor mainTextColor]];
}

- (void)configureWithRecipient:(Recipient *)recipient {
    [self.nameLabel setText:[recipient name]];
}

@end
