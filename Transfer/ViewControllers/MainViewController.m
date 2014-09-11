//
//  MainViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MainViewController.h"
#import "TransactionsViewController.h"
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
#import "ProfilesEditViewController.h"
#import "InvitationsViewController.h"

@interface MainViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) TabViewController *tabController;
@property (nonatomic, strong) UIView *revealTapView;
@property (nonatomic, strong) TransactionsViewController *transactionsController;
@property (nonatomic, assign) BOOL launchTableViewGamAdjustmentDone;
@property (nonatomic) BOOL shown;

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
    
    self.navigationBar.translucent = NO;
    
    TransactionsViewController *transactionsController = [[TransactionsViewController alloc] init];
    [self setTransactionsController:transactionsController];
    [transactionsController setObjectModel:self.objectModel];
    TabItem *transactionsItem = [TabItem new];
    transactionsItem.viewController = transactionsController;
    transactionsItem.title = NSLocalizedString(@"transactions.controller.tabbar.title", nil);
    transactionsItem.icon = [UIImage imageNamed:@"Transfers"];
    transactionsItem.selectedIcon = [UIImage imageNamed:@"Transfers_selected"];

    
    InvitationsViewController* invitationController = [[InvitationsViewController alloc] init];
    TabItem *inviteItem = [TabItem new];
    invitationController.objectModel = self.objectModel;
    inviteItem.title = NSLocalizedString(@"invite.controller.tabbar.title", nil);
    inviteItem.icon = [UIImage imageNamed:@"Invite"];
    inviteItem.selectedIcon = [UIImage imageNamed:@"Invite_selected"];
    inviteItem.viewController = invitationController;

    
    TabItem *paymentItem = [TabItem new];
    paymentItem.title = NSLocalizedString(@"payment.controller.tabbar.title", nil);
    paymentItem.icon = [UIImage imageNamed:@"Payment"];
    paymentItem.selectedIcon = [UIImage imageNamed:@"Payment_selected"];
    paymentItem.deSelectedColor = [UIColor colorFromStyle:@"TWBlueHighlighted"];
    paymentItem.textColor = [UIColor whiteColor];
    [paymentItem setActionBlock:^(TabItem* item){
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
        [controller setObjectModel:self.objectModel];
       ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:controller navBarHidden:YES];
        [self presentViewController:wrapper animated:YES completion:nil];
        [[GoogleAnalytics sharedInstance] sendScreen:@"New payment"];
        return NO;
    }];


    ContactsViewController *contactsController = [[ContactsViewController alloc] init];
    [contactsController setObjectModel:self.objectModel];
    TabItem *contactsItem = [TabItem new];
    contactsItem.title = NSLocalizedString(@"contacts.controller.tabbar.title", nil);
    contactsItem.icon = [UIImage imageNamed:@"Contacts"];
    contactsItem.selectedIcon = [UIImage imageNamed:@"Contacts_selected"];
    contactsItem.viewController = contactsController;
    
	ProfilesEditViewController *profileController = [[ProfilesEditViewController alloc] init];
	[profileController setObjectModel:self.objectModel];
	
	TabItem *profileItem = [TabItem new];
    profileItem.title = NSLocalizedString(@"profile.controller.tabbar.title", nil);
    profileItem.icon = [UIImage imageNamed:@"Profile"];
    profileItem.selectedIcon = [UIImage imageNamed:@"Profile_selected"];
	profileItem.viewController = IPAD ? [[UINavigationController alloc] initWithRootViewController:profileController] : profileController;
    TabViewController *tabController = [[TabViewController alloc] init];
    tabController.defaultSelectedColor = [UIColor colorFromStyle:@"TWBlue"];
    tabController.defaultDeSelectedColor = [UIColor colorFromStyle:@"TWBlue"];
    tabController.defaultHighlightedColor = [UIColor colorFromStyle:@"TWBlueHighlighted"];
    
    if(IPAD)
    {
        [tabController setItems:@[paymentItem,transactionsItem,inviteItem,contactsItem,profileItem]];
        tabController.tabBarInsets = UIEdgeInsetsMake(20, 0, 20, 0);
		tabController.centerVertically = YES;
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
	
    if (![Credentials userLoggedIn])
	{
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setDummyPresentation:YES];
        [self setNavigationBarHidden:YES];
        [self pushViewController:controller animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[self presentNewPaymentViewController];
	[self setShown:YES];
}

- (void)loggedOut
{
	[self clearData];
    [self presentNewPaymentViewController];
}

- (void)presentNewPaymentViewController
{
	if (![Credentials userLoggedIn])
	{
		UIViewController *presented;
		if ([self.objectModel shouldShowDirectUserSignup])
		{
			SignUpViewController *controller = [[SignUpViewController alloc] init];
			[controller setObjectModel:self.objectModel];
			presented = controller;
		}
		else
		{
			NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
			[controller setObjectModel:self.objectModel];
			presented = controller;
		}
		
		ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:presented navBarHidden:YES];
		[self presentViewController:wrapper animated:YES completion:nil];
		[self popToRootViewControllerAnimated:NO];
	}
}

- (void)clearData
{
	[[TransferwiseClient sharedClient] clearCredentials];
	[self.transactionsController clearData];
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

@end
