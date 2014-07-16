//
//  RecipientCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientCell.h"
#import "UIColor+Theme.h"
#import "Recipient.h"

@interface RecipientCell ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *bankLabel;

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
}

- (void)configureWithRecipient:(Recipient *)recipient {
    [self.nameLabel setText:[recipient name]];
    [self.bankLabel setText:[recipient presentationStringFromAllValues]];
}

@end
