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
#import "Credentials.h"
#import "GoogleAnalytics.h"
#import "IntroViewController.h"
#import "SignUpViewController.h"
#import "ObjectModel+Recipients.h"
#import "ObjectModel+Settings.h"
#import "TabViewController.h"

@interface MainViewController () <UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarController *tabsController;
@property (nonatomic, strong) UIView *revealTapView;
@property (nonatomic, strong) UIViewController *transactionsController;
@property (nonatomic, assign) BOOL launchTableViewGamAdjustmentDone;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) UIViewController *paymentController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:TRWLoggedOutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentsList) name:TRWMoveToPaymentsListNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentView) name:TRWMoveToPaymentViewNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *selectedColor = [UIColor blackColor];
    
    TabViewController *tabController = [[TabViewController alloc] init];
    
    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];
    [self setTransactionsController:transactionsController];
    [transactionsController setObjectModel:self.objectModel];
    TabItem *tabItem = [TabItem new];
    tabItem.selectedColor = selectedColor;
    tabItem.viewController = transactionsController;
    [tabController addItem:tabItem];

    PaymentViewController *paymentController = [[PaymentViewController alloc] init];
    [self setPaymentController:paymentController];
    [paymentController setObjectModel:self.objectModel];
    tabItem = [TabItem new];
    tabItem.selectedColor = selectedColor;
    tabItem.viewController = paymentController;
    [tabController addItem:tabItem];


    ContactsViewController *contactsController = [[ContactsViewController alloc] init];
    [contactsController setObjectModel:self.objectModel];
    tabItem = [TabItem new];
    tabItem.selectedColor = selectedColor;
    tabItem.viewController = contactsController;
    [tabController addItem:tabItem];

//    UITabBarController *tabController = [[UITabBarController alloc] init];
//    [tabController setViewControllers:@[transactionsController, paymentController, contactsController]];
//    [tabController setDelegate:self];
//    [self setTabsController:tabController];

    [self setViewControllers:@[tabController]];

    SWRevealViewController *revealController = [self revealViewController];
    [self.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];

    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(menuPressed)];
    [tabController.navigationItem setLeftBarButtonItem:settingsButton];

    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TWlogo.png"]];
    [tabController.navigationItem setTitleView:logoView];

    [self setDelegate:self];

    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)menuPressed {
	[[GoogleAnalytics sharedInstance] sendAppEvent:@"Menu clicked"];
	[self.revealViewController revealToggle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.launchTableViewGamAdjustmentDone) {
        return;
    }

    [self.tabsController setSelectedIndex:1];
    [self.tabsController setSelectedIndex:0];
    [self setLaunchTableViewGamAdjustmentDone:YES];

    if (![Credentials userLoggedIn] && !self.shown && ![self.objectModel hasIntroBeenShown]) {
        IntroViewController *controller = [[IntroViewController alloc] init];
        [self setNavigationBarHidden:YES];
        [self pushViewController:controller animated:NO];
    } else if (![Credentials userLoggedIn] && !self.shown) {
        IntroductionViewController *controller = [[IntroductionViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setDummyPresentation:YES];
        [self setNavigationBarHidden:YES];
        [self pushViewController:controller animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![Credentials userLoggedIn]) {
        [self presentIntroductionController:self.shown];
        [self popToRootViewControllerAnimated:NO];
    }

    [self setShown:YES];
}

- (void)presentIntroductionController:(BOOL)shownBefore {
    UIViewController *presented;
    if (shownBefore || [self.objectModel hasIntroBeenShown]) {
        if ([self.objectModel shouldShowDirectUserSignup]) {
            SignUpViewController *controller = [[SignUpViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            presented = controller;
        } else {
            IntroductionViewController *controller = [[IntroductionViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            presented = controller;
        }
    } else {
        IntroViewController *controller = [[IntroViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        presented = controller;
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:presented];
    [navigationController setNavigationBarHidden:!shownBefore];
    [self presentViewController:navigationController animated:shownBefore completion:nil];
}

- (void)loggedOut {
    [self presentIntroductionController:YES];
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
    UIPanGestureRecognizer *directionPanGestureRecognizer = [revealController directionPanGestureRecognizer];
    [directionPanGestureRecognizer setDelegate:nil];
    [tapView addGestureRecognizer:directionPanGestureRecognizer];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveToPaymentView {
    self.tabsController.selectedViewController = self.paymentController;
    [self popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.paymentController) {
        [[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];
    }
}

@end
