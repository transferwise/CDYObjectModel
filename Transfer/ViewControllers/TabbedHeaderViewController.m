//
//  TabbedHeaderViewController.m
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"
#import "HeaderTabView.h"

@interface TabbedHeaderViewController ()

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic,weak) IBOutlet HeaderTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewHeightConstraint;
@property (nonatomic,weak) IBOutlet UIButton *actionButton;

@end

@implementation TabbedHeaderViewController


@end
