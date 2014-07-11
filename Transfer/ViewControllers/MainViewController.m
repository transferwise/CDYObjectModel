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
#import "NewPaymentViewController.h"
#import "Credentials.h"
#import "GoogleAnalytics.h"
#import "IntroViewController.h"
#import "SignUpViewController.h"
#import "ObjectModel+Recipients.h"
#import "ObjectModel+Settings.h"
#import "TabViewController.h"
#import "UIColor+MOMStyle.h"
#import "TransferwiseClient.h"
#import "ConnectionAwareViewController.h"

@interface MainViewController () <UINavigationControllerDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) TabViewController *tabController;
@property (nonatomic, strong) UIView *revealTapView;
@property (nonatomic, strong) UIViewController *transactionsController;
@property (nonatomic, assign) BOOL launchTableViewGamAdjustmentDone;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) PaymentViewController *paymentController;

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
    
    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];
    [self setTransactionsController:transactionsController];
    [transactionsController setObjectModel:self.objectModel];
    TabItem *transactionsItem = [TabItem new];
    transactionsItem.viewController = transactionsController;
    transactionsItem.title = NSLocalizedString(@"transactions.controller.tabbar.title", nil);
    transactionsItem.icon = [UIImage imageNamed:@"TransactionsTabIcon.png"];

    
    TabItem *inviteItem = [TabItem new];
    [inviteItem setActionBlock:^(TabItem* item){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Not implemented yet!" message:nil delegate:nil cancelButtonTitle:@"Aha!" otherButtonTitles:nil];
        [alert show];
        return NO;
    }];
    inviteItem.title = NSLocalizedString(@"invite.controller.tabbar.title", nil);
    inviteItem.icon = [UIImage imageNamed:@"tab_icon_invite"];

    
    TabItem *paymentItem = [TabItem new];
    paymentItem.title = NSLocalizedString(@"payment.controller.tabbar.title", nil);
    paymentItem.icon = [UIImage imageNamed:@"NewPaymentTabIcon.png"];
    paymentItem.deSelectedColor = [UIColor colorFromStyle:@"TWBlueHighlighted"];
    paymentItem.textColor = [UIColor whiteColor];
    [paymentItem setActionBlock:^(TabItem* item){
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [navigationController setNavigationBarHidden:YES];
        ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
        [self presentViewController:wrapper animated:YES completion:nil];
        return NO;
    }];


    ContactsViewController *contactsController = [[ContactsViewController alloc] init];
    [contactsController setObjectModel:self.objectModel];
    TabItem *contactsItem = [TabItem new];
    contactsItem.title = NSLocalizedString(@"contacts.controller.tabbar.title", nil);
    contactsItem.icon = [UIImage imageNamed:@"ContactsIcon.png"];
    contactsItem.viewController = contactsController;
    
    TabItem *profileItem = [TabItem new];
    [profileItem setActionBlock:^(TabItem* item){
        [[TransferwiseClient sharedClient] clearCredentials];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cleared credentials!" message:nil delegate:nil cancelButtonTitle:@"Aha!" otherButtonTitles:nil];
        [alert show];
        [self loggedOut];
        return NO;
    }];
    profileItem.title = NSLocalizedString(@"profile.controller.tabbar.title", nil);
    profileItem.icon = [UIImage imageNamed:@"tab_icon_profile"];
    
    TabViewController *tabController = [[TabViewController alloc] init];
    tabController.defaultSelectedColor = [UIColor colorFromStyle:@"TWBlue"];
    tabController.defaultDeSelectedColor = [UIColor colorFromStyle:@"TWBlue"];
    tabController.defaultHighlightedColor = [UIColor colorFromStyle:@"TWBlueHighlighted"];
    
    if(IPAD)
    {
        [tabController setItems:@[paymentItem,transactionsItem,inviteItem,contactsItem,profileItem]];
        tabController.tabBarInsets = UIEdgeInsetsMake(20, 0, 20,0);
        [self setNavigationBarHidden:YES];
    }
    else
    {
        [tabController setItems:@[transactionsItem,inviteItem,paymentItem,contactsItem,profileItem]];
    }
    
    [tabController selectItem:transactionsItem];
    
    self.tabController = tabController;

    [self setViewControllers:@[tabController]];

    [self setDelegate:self];
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

    [self setLaunchTableViewGamAdjustmentDone:YES];

    if (![Credentials userLoggedIn] && !self.shown && ![self.objectModel hasIntroBeenShown]) {
        IntroViewController *controller = [[IntroViewController alloc] init];
        [self setNavigationBarHidden:YES];
        [self pushViewController:controller animated:NO];
    } else if (![Credentials userLoggedIn] && !self.shown) {
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
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
            NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            presented = controller;
        }
    } else {
        IntroViewController *controller = [[IntroViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        presented = controller;
    }

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:presented];
    [navigationController setNavigationBarHidden:YES];
    ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
    [self presentViewController:wrapper animated:shownBefore completion:nil];
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

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)vieTwController animated:(BOOL)animated
{
    
}

- (void)moveToPaymentsList {
    [self.tabController selectIndex:IPAD?1:0];
    [self popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveToPaymentView {
    [self.tabController selectIndex:IPAD?0:2];
    [self popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController == self.paymentController && tabBarController.selectedViewController != self.paymentController) {
        [self.paymentController resetAmountsToDefault];
    }

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (viewController == self.paymentController) {
        [[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];
    }
}

@end
