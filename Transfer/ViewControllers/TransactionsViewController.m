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
#import "TRWProgressHUD.h"
#import "PlainPayment.h"

NSString *const kPaymentCellIdentifier = @"kPaymentCellIdentifier";

@interface TransactionsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) PaymentsOperation *executedOperation;
@property (nonatomic, strong) NSArray *activeTransfers;
@property (nonatomic, strong) NSArray *completePayments;
@property (nonatomic, strong) NSArray *presentedSections;
@property (nonatomic, strong) NSArray *presentedSectionTitles;
@property (nonatomic, strong) IBOutlet UIView *loadingFooterView;
@property (nonatomic, strong) NSArray *allPayments;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self refreshPaymentsList];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presentedSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.presentedSections[section] count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellIdentifier];

    PlainPayment *payment = self.presentedSections[indexPath.section][indexPath.row];

    [cell configureWithPayment:payment];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.presentedSectionTitles[section];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshPaymentsList {
    [self setAllPayments:@[]];
    [self setPayments:@[]];
    [self.tableView setTableFooterView:nil];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"transactions.controller.refreshing.message", nil)];

    [self refreshPaymentsWithOffset:0 hud:hud];
}

- (void)refreshPaymentsWithOffset:(NSInteger)offset hud:(TRWProgressHUD *)hud {
    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:offset];
    [self setExecutedOperation:operation];

    [operation setCompletion:^(NSInteger totalCount, NSArray *payments, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            [self setExecutedOperation:nil];
            [self setAllPayments:[self.allPayments arrayByAddingObjectsFromArray:payments]];
            [self setPayments:self.allPayments];
            if (totalCount > [self.allPayments count]) {
                [self.tableView setTableFooterView:self.loadingFooterView];
            } else {
                [self.tableView setTableFooterView:nil];
            }
            [self.tableView reloadData];
        });
    }];

    [operation execute];
}

- (void)setPayments:(NSArray *)allPayments {
    [self setActiveTransfers:[allPayments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        PlainPayment *payment = evaluatedObject;
        return [payment isActive];
    }]]];

    [self setCompletePayments:[allPayments filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        PlainPayment *payment = evaluatedObject;
        return ![payment isActive];
    }]]];

    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *titles = [NSMutableArray array];
    if ([self.activeTransfers count] > 0) {
        [sections addObject:self.activeTransfers];
        [titles addObject:NSLocalizedString(@"transactions.controller.active.transfers.section.title", nil)];
    }

    if ([self.completePayments count] > 0) {
        [sections addObject:self.completePayments];
        [titles addObject:NSLocalizedString(@"transactions.controller.completed.transfers.section.title", nil)];
    }

    [self setPresentedSections:sections];
    [self setPresentedSectionTitles:titles];
    [self.tableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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

    BOOL footerVisible = CGRectIntersectsRect(self.view.bounds, self.loadingFooterView.frame);
    if (!footerVisible) {
        return;
    }

    [self refreshPaymentsWithOffset:[self.allPayments count] hud:nil];
}

@end
