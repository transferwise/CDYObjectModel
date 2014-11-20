//
//  AchWaitingViewController.m
//  Transfer
//
//  Created by Mats Trovik on 19/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchWaitingViewController.h"
#import "SupportCoordinator.h"

@interface AchWaitingViewController ()
@property (nonatomic, weak)IBOutlet UIImageView *image;
@property (nonatomic, assign) BOOL animate;
@end

@implementation AchWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoText = NSLocalizedString(@"ach.waiting.info", nil);
    self.actionButtonTitle = NSLocalizedString(@"transferdetails.controller.button.support", nil);
    self.infoImage = [UIImage imageNamed:@"refreshFlag%ld"];
    __weak typeof(self) weakSelf = self;
    self.actionButtonBlock = ^{
        if(weakSelf)
        {
            [[SupportCoordinator sharedInstance] presentOnController:weakSelf];
        }
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.animate = YES;
    [self animateFlag];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.animate = NO;
}


-(void)animateFlag
{
    if(self.animate)
    {
        [UIView transitionWithView:self.image duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
            self.image.tag = ++self.image.tag%3;
            self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"refreshFlag%ld",(long)self.image.tag]];
        } completion:^(BOOL finished) {
            [self animateFlag];
        }];
    }
}


@end
