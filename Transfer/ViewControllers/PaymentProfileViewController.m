//
//  PaymentProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentProfileViewController.h"
#import "PersonalProfileSource.h"
#import "ProfileSelectionView.h"
#import "UIView+Loading.h"

@interface PaymentProfileViewController ()

@property (nonatomic, strong) ProfileSelectionView *profileSelectionView;

@end

@implementation PaymentProfileViewController

- (id)init {
    self = [super initWithSource:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.allowProfileSwitch) {
        [self setProfileSelectionView:[ProfileSelectionView loadInstance]];
        [self setPresentProfileSource:[self.profileSelectionView presentedSource] reloadView:NO];
    } else {
        [self setPresentProfileSource:[[PersonalProfileSource alloc] init] reloadView:NO];
    }

    __block __weak PaymentProfileViewController *weakSelf = self;
    [self.profileSelectionView setSelectionHandler:^(ProfileSource *selected) {
        [weakSelf setPresentProfileSource:selected reloadView:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.profileSelectionView;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGRectGetHeight(self.profileSelectionView.frame);
    }

    return 0;
}

@end
