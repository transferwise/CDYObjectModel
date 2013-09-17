//
//  BusinessProfileViewController.m
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "BusinessProfileViewController.h"
#import "BusinessProfileSource.h"
#import "QuickProfileValidationOperation.h"
#import "GoogleAnalytics.h"

@interface BusinessProfileViewController ()

@end

@implementation BusinessProfileViewController

- (id)init {
    self = [super initWithSource:[[BusinessProfileSource alloc] init] quickValidation:[QuickProfileValidationOperation businessProfileValidation]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[[GoogleAnalytics sharedInstance] sendAppEvent:@"BusinessProfile"];
}


@end
