//
//  TableHeaderView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TableHeaderView.h"

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

    //TODO jaanus: move to theme definion and name color
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.435 green:0.467 blue:0.529 alpha:1.000]];
    [self.titleLabel setText:NSLocalizedString(@"introduction.header.title.text", nil)];
}

- (void)setMessage:(NSString *)message {
    [self.titleLabel setText:message];
}


@end
