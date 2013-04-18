//
//  SettingsTitleCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SettingsTitleCell.h"

@interface SettingsTitleCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation SettingsTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

@end
