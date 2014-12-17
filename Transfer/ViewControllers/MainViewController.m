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
#import "SendButtonFlashHelper.h"
#import "NavigationBarCustomiser.h"


@interface MainViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) TabViewController *tabController;
@property (nonatomic, strong) UIView *revealTapView;
@property (nonatomic, strong) TransactionsViewController *transactionsController;
@property (nonatomic, strong) ContactsViewController *contactsController;
@property (nonatomic, strong) ProfilesEditViewController *profileController;
@property (nonatomic, assign) BOOL launchTableViewGamAdjustmentDone;
@property (nonatomic) BOOL shown;
@property (nonatomic) BOOL isShowingLoginScreen;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedOut) name:TRWLoggedOutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentsList) name:TRWMoveToPaymentsListNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentView) name:TRWMoveToPaymentViewNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSendButtonFlashNotification:) name:TRWChangeSendButtonFlashStatusNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
	self.navigationBarHidden = YES;
    
	[self setUpTabs];
    [self setDelegate:self];
}

- (void)setUpTabs
{
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
    paymentItem.flashColor = [UIColor colorFromStyle:@"TWElectricblueDarker"];
	[paymentItem setActionBlock:^(TabItem* item){
		NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
		[controller setObjectModel:self.objectModel];
		ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:controller navBarHidden:YES];
		[self presentViewController:wrapper animated:YES completion:nil];
		return NO;
	}];
	
	
	ContactsViewController *contactsController = [[ContactsViewController alloc] init];
	[self setContactsController:contactsController];
	[contactsController setObjectModel:self.objectModel];
	TabItem *contactsItem = [TabItem new];
	contactsItem.title = NSLocalizedString(@"contacts.controller.tabbar.title", nil);
	contactsItem.icon = [UIImage imageNamed:@"Contacts"];
	contactsItem.selectedIcon = [UIImage imageNamed:@"Contacts_selected"];
	contactsItem.viewController = contactsController;
	
	ProfilesEditViewController *profileController = [[ProfilesEditViewController alloc] init];
	[self setProfileController:profileController];
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
	
	if (![Credentials userLoggedIn])
	{
		[self setViewControllers:@[[self getIntroViewController]]];
	}
	else
	{
		[self setViewControllers:@[self.tabController]];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [NavigationBarCustomiser setDefault];
    
    if (self.launchTableViewGamAdjustmentDone)
	{
        return;
    }

    [self setLaunchTableViewGamAdjustmentDone:YES];
}

- (void)loggedOut
{
    [self clearData];
    void (^showLoginBlock)(void) = ^{
        [self presentViewController:[self getIntroViewController]
                           animated:YES
                         completion:^{
                             [self.tabController selectIndex:IPAD?1:0];
                         }];
        [self popToRootViewControllerAnimated:NO];
    };
    if(self.presentedViewController){

        NSTimeInterval delay = 0.0f;
        if([self.presentedViewController isBeingPresented]||[self.presentedViewController isBeingDismissed])
        {
            delay = 0.3f;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    showLoginBlock();
                });
                
            }];
        });
    }
    else
    {
        showLoginBlock();
    }
}

- (ConnectionAwareViewController *)getIntroViewController
{
    IntroViewController *introController = [[IntroViewController alloc] init];
    [introController setObjectModel:self.objectModel];
    introController.requireRegistration = YES;

	ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:introController navBarHidden:YES];
	return wrapper;
}

- (void)clearData
{
	[[TransferwiseClient sharedClient] clearCredentials];
	[self.transactionsController clearData];
	[self.contactsController clearData];
	[self.profileController clearData];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger numberOfControllers = [navigationController.viewControllers count];
    
    NSArray *recognizers = [navigationController.navigationBar gestureRecognizers];
    for (UIGestureRecognizer *recognizer in recognizers)
	{
        [recognizer setEnabled:numberOfControllers == 1];
    }
}


- (void)moveToPaymentsList
{
    [self.tabController selectIndex:IPAD?1:0];
    [self popToRootViewControllerAnimated:YES];
	[self setViewControllers:@[self.tabController]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)moveToPaymentView
{
    [self.tabController selectIndex:IPAD?0:2];
    [self popToRootViewControllerAnimated:YES];
	[self setViewControllers:@[self.tabController]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Highlight Send Button

-(void)changeSendButtonFlashNotification:(NSNotification*) note;
{
    BOOL turnedOn = [note.userInfo[TRWChangeSendButtonFlashOnOffKey] boolValue];
    if(turnedOn)
    {
        [self.tabController turnOnFlashForItemAtIndex:IPAD?0:2];
    }
    else
    {
        [self.tabController turnOffFlashForItemAtIndex:IPAD?0:2];
    }
}

@end
