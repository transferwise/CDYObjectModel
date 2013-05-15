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
#import "IntroductionViewController.h"
#import "SettingsViewController.h"
#import "Credentials.h"
#import "SWRevealViewController.h"
#import "Constants.h"

@interface MainViewController ()

@property (nonatomic, strong) UITabBarController *tabsController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:TRWLoggedOutNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];

    PaymentViewController *paymentController = [[PaymentViewController alloc] init];

    ContactsViewController *contactsController = [[ContactsViewController alloc] init];

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:@[transactionsController, paymentController, contactsController]];
    [self setTabsController:tabController];

    [self setViewControllers:@[tabController]];

    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButtonIcon.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [tabController.navigationItem setLeftBarButtonItem:settingsButton];

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    [tabController.navigationItem setTitleView:logoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (![Credentials userLoggedIn]) {
        [self presentIntroductionController];
    }
}

- (void)presentIntroductionController {
    IntroductionViewController *controller = [[IntroductionViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    
    SettingsViewController *rearViewController = [[SettingsViewController alloc] init];
    [rearViewController setObjectModel:self.objectModel];
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearViewController frontViewController:navigationController];
    [self presentModalViewController:mainRevealController animated:YES];
}

- (void)loggedOut {
    [self presentIntroductionController];
}

@end
