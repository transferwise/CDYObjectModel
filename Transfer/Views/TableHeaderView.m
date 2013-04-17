//
//  TableHeaderView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TableHeaderView.h"
#import "UIColor+Theme.h"

@interface TableHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation TableHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.titleLabel setTextColor:[UIColor mainTextColor]];
    [self.titleLabel setText:NSLocalizedString(@"introduction.header.title.text", nil)];
}

- (void)setMessage:(NSString *)message {
    [self.titleLabel setText:message];
}


@end
