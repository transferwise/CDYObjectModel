//
//  PersonalProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "PersonalProfileSource.h"
#import "QuickProfileValidationOperation.h"

@interface PersonalProfileViewController ()

@end

@implementation PersonalProfileViewController

- (id)init {
    self = [super initWithSource:[[PersonalProfileSource alloc] init] quickValidation:[QuickProfileValidationOperation personalProfileValidation]];
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

@end
