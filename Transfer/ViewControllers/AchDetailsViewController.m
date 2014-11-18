//
//  AchDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 18.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchDetailsViewController.h"
#import "NSString+DeviceSpecificLocalisation.h"

@interface AchDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@end

@implementation AchDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:NSLocalizedString(@"", nil)];
	[self.supportButton setTitle:NSLocalizedString([@"ach.controller.button.support" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
}

@end
