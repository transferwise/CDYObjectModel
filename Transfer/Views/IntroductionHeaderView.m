//
//  IntroductionHeaderView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionHeaderView.h"

@interface IntroductionHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation IntroductionHeaderView

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

@end
