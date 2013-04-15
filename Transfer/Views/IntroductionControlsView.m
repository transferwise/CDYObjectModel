//
//  IntroductionControlsView.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroductionControlsView.h"

@interface IntroductionControlsView ()

@property (nonatomic, strong) IBOutlet UILabel *savingsLabel;
@property (nonatomic, strong) IBOutlet UILabel *loginTitle;
@property (nonatomic, strong) IBOutlet UIButton *startedButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@end

@implementation IntroductionControlsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.savingsLabel setText:@""];
    [self.loginTitle setText:NSLocalizedString(@"introduction.login.section.title", nil)];

    [self.startedButton setTitle:NSLocalizedString(@"button.title.get.started", nil) forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"button.title.log.in", nil) forState:UIControlStateNormal];
}

@end
