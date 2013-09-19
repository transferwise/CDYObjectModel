//
//  TransactionsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransactionsViewController.h"
#import "PaymentsOperation.h"
#import "UIColor+Theme.h"
#import "PaymentCell.h"
#import "ObjectModel.h"
#import "ObjectModel+Payments.h"
#import "TabBarActivityIndicatorView.h"
#import "Payment.h"
#import "BankTransferViewController.h"
#import "ConfirmPaymentViewController.h"
#import "PaymentDetailsViewController.h"
#import "Recipient.h"
#import "RecipientType.h"
#import "UploadMoneyViewController.h"
#import "GoogleAnalytics.h"
#import "IdentificationNotificationView.h"
#import "UIView+Loading.h"
#import "CheckPersonalProfileVerificationOperation.h"

NSString *const kPaymentCellIdentifier = @"kPaymentCellIdentifier";

@interface TransactionsViewController () <UIScrollViewDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PaymentsOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *loadingFooterView;
@property (nonatomic, strong) NSFetchedResultsController *payments;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IdentificationNotificationView *identificationView;
@property (nonatomic, assign) BOOL showIdentificationView;
@property (nonatomic, strong) CheckPersonalProfileVerificationOperation *checkOperation;

@end

@implementation TransactionsViewController

- (id)init {
    self = [super initWithNibName:@"TransactionsViewController" bundle:nil];
    if (self) {
        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"transactions.controller.title", nil) image:[UIImage imageNamed:@"TransactionsTabIcon.png"] tag:0];
        [self setTabBarItem:barItem];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:kPaymentCellIdentifier];

    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footer];

    if (IOS_7) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

	IdentificationNotificationView *notificationView = [IdentificationNotificationView loadInstance];
	[self setIdentificationView:notificationView];
	[notificationView setTapHandler:^{
		[self pushIdentificationScreen];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];

    [self.tableView setContentOffset:CGPointZero];

    if (!self.payments) {
        NSFetchedResultsController *controller = [self.objectModel fetchedControllerForAllPayments];
        [self setPayments:controller];
        [controller setDelegate:self];
        [self.tableView reloadData];
    }

    [self refreshPaymentsList];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];

	[self checkPersonalVerificationNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[[GoogleAnalytics sharedInstance] sendAppEvent:@"TransfersList"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.payments sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.payments sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellIdentifier];

    Payment *payment = [self.payments objectAtIndexPath:indexPath];

    [cell configureWithPayment:payment];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    Payment *payment = [self.payments objectAtIndexPath:indexPath];
    if ([payment.recipient.type hideFromCreationValue]) {
        return;
    }

	[[GoogleAnalytics sharedInstance] sendAppEvent:@"ViewPayment"];

    if ([payment isSubmitted]) {
        UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
        [controller setPayment:payment];
        [controller setObjectModel:self.objectModel];
        [controller setHideBottomButton:YES];
        [controller setShowContactSupportCell:YES];
        [self.navigationController pushViewController:controller animated:YES];
    } else if ([payment isCancelled] || [payment moneyReceived] || [payment moneyTransferred]) {
        PaymentDetailsViewController *controller = [[PaymentDetailsViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        [controller setPayment:payment];
        [controller setShowContactSupportCell:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0 && self.showIdentificationView) {
		return CGRectGetHeight(self.identificationView.frame);
	}

	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0 && self.showIdentificationView) {
		return self.identificationView;
	}

	return nil;
}

- (void)refreshPaymentsList {
    if (self.executedOperation) {
        return;
    }

    [self.tableView setTableFooterView:nil];

    TabBarActivityIndicatorView *hud = [TabBarActivityIndicatorView showHUDOnController:self];
    [hud setMessage:NSLocalizedString(@"transactions.controller.refreshing.message", nil)];

    [self refreshPaymentsWithOffset:0 hud:hud];
}

- (void)refreshPaymentsWithOffset:(NSInteger)offset hud:(TabBarActivityIndicatorView *)hud {
    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:offset];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletion:^(NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            [self setExecutedOperation:nil];
            if (totalCount > [self.payments.fetchedObjects count]) {
                [self.tableView setTableFooterView:self.loadingFooterView];
            } else {
                [self.tableView setTableFooterView:nil];
            }
            [self.tableView reloadData];
        });
    }];

    [operation execute];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkReloadNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self checkReloadNeeded];
    }
}

- (void)checkReloadNeeded {
    if (!self.tableView.tableFooterView) {
        return;
    }

    if (self.executedOperation) {
        return;
    }

    BOOL footerVisible = CGRectIntersectsRect(self.tableView.bounds, self.loadingFooterView.frame);
    if (!footerVisible) {
        return;
    }

    [self refreshPaymentsWithOffset:[self.payments.fetchedObjects count] hud:nil];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch (type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)checkPersonalVerificationNeeded {
	MCLog(@"checkPersonalVerificationNeeded", nil);
	if (self.checkOperation) {
		MCLog(@"Check in progress");
		return;
	}

	CheckPersonalProfileVerificationOperation *operation = [CheckPersonalProfileVerificationOperation operation];
	[self setCheckOperation:operation];
	[operation setResultHandler:^(BOOL somethingNeeded) {
		[self setCheckOperation:nil];

		if (somethingNeeded != self.showIdentificationView) {
			[self setShowIdentificationView:somethingNeeded];
			[self.tableView reloadData];
		}
	}];
	[operation execute];
}

- (void)pushIdentificationScreen {
	MCLog(@"pushIdentificationScreen");
}

@end
