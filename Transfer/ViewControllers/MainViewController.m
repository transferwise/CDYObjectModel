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
#import "SettingsViewController.h"
#import "Credentials.h"
#import "SWRevealViewController.h"

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

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:@[transactionsController, paymentController, contactsController]];
    [self setTabsController:tabController];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabController];
    [self addChildViewController:navigationController];

    [navigationController.view setFrame:self.view.bounds];
    [self.view addSubview:navigationController.view];

    SWRevealViewController *revealController = [self revealViewController];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButtonIcon.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [tabController.navigationItem setLeftBarButtonItem:settingsButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)presentIntroductionController {
    IntroductionViewController *controller = [[IntroductionViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:navigationController animated:NO];
}

- (void)settingsPressed {
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
