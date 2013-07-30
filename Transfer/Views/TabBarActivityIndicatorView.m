//
//  TabBarActivityIndicatorView.m
//  Transfer
//
//  Created by Jaanus Siim on 7/1/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TabBarActivityIndicatorView.h"
#import "UIView+Loading.h"
#import "Constants.h"
#import "SpinningImageView.h"

@interface TabBarActivityIndicatorView ()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet SpinningImageView *spinner;

@end

@implementation TabBarActivityIndicatorView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];

    [self.spinner stop];
}

- (void)setMessage:(NSString *)message {
    [self.messageLabel setText:message];

    CGFloat messageWidth = [self.messageLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(self.messageLabel.frame))].width;
    CGFloat messageX = (CGRectGetWidth(self.messageLabel.frame) - messageWidth) / 2;
    CGFloat spinnerX = messageX - CGRectGetWidth(self.spinner.frame) - 10;

    CGRect spinnerFrame = self.spinner.frame;
    spinnerFrame.origin.x = CGRectGetMinX(self.messageLabel.frame) + spinnerX;
    [self.spinner setFrame:spinnerFrame];
}

- (void)hide {
    [self removeFromSuperview];
}

+ (TabBarActivityIndicatorView *)showHUDOnController:(UIViewController *)controller {
    TabBarActivityIndicatorView *indicatorView = [TabBarActivityIndicatorView loadInstance];
    UITabBarController *tabBarController = controller.tabBarController;
    MCAssert(tabBarController);
    CGFloat tabHeight = CGRectGetHeight(tabBarController.tabBar.frame);

    CGRect indicatorFrame = indicatorView.frame;
    indicatorFrame.origin.y = CGRectGetHeight(tabBarController.view.frame) - tabHeight - CGRectGetHeight(indicatorFrame);
    [indicatorView setFrame:indicatorFrame];
    [tabBarController.view addSubview:indicatorView];
    return indicatorView;
}

@end
