//
//  MainViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MainViewController.h"
#import "TransactionsViewController.h"
#import "PaymentViewController.h"
#import "ContactsViewController.h"
#import "ObjectModel.h"
#import "IntroductionViewController.h"
#import "ObjectModel+Credentials.h"

@interface MainViewController ()

@property (nonatomic, strong) UITabBarController *tabsController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];

    PaymentViewController *paymentController = [[PaymentViewController alloc] init];

    ContactsViewController *contactsController = [[ContactsViewController alloc] init];
    [contactsController setObjectModel:self.objectModel];

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:@[transactionsController, paymentController, contactsController]];
    [self setTabsController:tabController];

    [tabController.view setFrame:self.view.bounds];
    [self.view addSubview:tabController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (![self.objectModel userLoggedIn]) {
        [self presentIntroductionController];
    }
}


- (void)presentIntroductionController {
    IntroductionViewController *controller = [[IntroductionViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navigationController animated:NO];
}

@end
