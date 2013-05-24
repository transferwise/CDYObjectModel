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
#import "Constants.h"

@interface MainViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabsController;
@property (nonatomic, strong) UIView *revealTapView;
@property (nonatomic, strong) UIViewController *transactionsController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:TRWLoggedOutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentsList) name:TRWMoveToPaymentsListNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];
    [self setTransactionsController:transactionsController];

    PaymentViewController *paymentController = [[PaymentViewController alloc] init];

    ContactsViewController *contactsController = [[ContactsViewController alloc] init];

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController setViewControllers:@[transactionsController, paymentController, contactsController]];
    [self setTabsController:tabController];

    [self setViewControllers:@[tabController]];

    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsButtonIcon.png"] style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    [tabController.navigationItem setLeftBarButtonItem:settingsButton];

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TWlogo.png"]];
    [tabController.navigationItem setTitleView:logoView];

    [self setDelegate:self];
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
    [navigationController setDelegate:self];

    mainRevealController.delegate = self;

    [self presentModalViewController:mainRevealController animated:YES];
}

- (void)loggedOut {
    [self presentIntroductionController];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    if (position != FrontViewPositionRight) {
        [self.revealTapView removeFromSuperview];
        return;
    }

    UIViewController *front = revealController.frontViewController;
    UIView *tapView = [[UIView alloc] initWithFrame:front.view.bounds];
    tapView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:revealController action:@selector(revealToggle:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [tapView addGestureRecognizer:tapRecognizer];
    [front.view addSubview:tapView];

    [self setRevealTapView:tapView];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSUInteger numberOfControllers = [navigationController.viewControllers count];
    NSArray *recognizers = [navigationController.navigationBar gestureRecognizers];
    for (UIGestureRecognizer *recognizer in recognizers) {
        [recognizer setEnabled:numberOfControllers == 1];
    }
}

- (void)moveToPaymentsList {
    self.tabsController.selectedViewController = self.transactionsController;
    [self popToRootViewControllerAnimated:YES];
}

@end
