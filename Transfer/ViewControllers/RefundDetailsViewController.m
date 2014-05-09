//
//  RefundDetailsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 08/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RefundDetailsViewController.h"
#import "TransferBackButtonItem.h"
#import "TextEntryCell.h"
#import "UIView+Loading.h"
#import "TransferTypeSelectionCell.h"
#import "RecipientTypeField.h"
#import "RecipientType.h"
#import "DropdownCell.h"
#import "ObjectModel+PendingPayments.h"
#import "ObjectModel+RecipientTypes.h"
#import "CurrenciesOperation.h"
#import "PendingPayment.h"
#import "RecipientFieldCell.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "Currency.h"
#import "UIColor+Theme.h"
#import "UITableView+FooterPositioning.h"
#import "Recipient.h"
#import "ObjectModel+Recipients.h"
#import "NSString+Validation.h"
#import "UIApplication+Keyboard.h"
#import "NSMutableString+Issues.h"
#import "RecipientOperation.h"
#import "AnalyticsCoordinator.h"

CGFloat const TransferHeaderPaddingTop = 40;
CGFloat const TransferHeaderPaddingBottom = 0;

@interface RefundDetailsViewController ()

@property (nonatomic, strong) TextEntryCell *holderNameCell;
@property (nonatomic, strong) TransferTypeSelectionCell *transferTypeSelectionCell;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, strong) NSArray *recipientTypeFieldCells;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, assign) CGFloat minimumFooterHeight;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) TransferwiseOperation *operation;

@end

@implementation RefundDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];
    if (IOS_7) {
        [self.tableView setSeparatorColor:[UIColor clearColor]];
    }

    [self.navigationItem setTitle:NSLocalizedString(@"refund.details.controller.title", nil)];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    [self.tableView registerNib:[TextEntryCell viewNib] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[TransferTypeSelectionCell viewNib] forCellReuseIdentifier:TWTypeSelectionCellIdentifier];
    [self.tableView registerNib:[DropdownCell viewNib] forCellReuseIdentifier:TWDropdownCellIdentifier];
    [self.tableView registerNib:[RecipientFieldCell viewNib] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];


    NSMutableArray *presentedSections = [NSMutableArray array];

    TextEntryCell *holderName = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setHolderNameCell:holderName];
    [holderName configureWithTitle:NSLocalizedString(@"refund.details.holders.name.label", nil) value:@""];

    [presentedSections addObject:@[holderName]];

    __weak RefundDetailsViewController *weakSelf = self;

    self.transferTypeSelectionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTypeSelectionCellIdentifier];
    [self.transferTypeSelectionCell setSelectionChangeHandler:^(RecipientType *type, NSArray *allTypes) {
        [weakSelf handleSelectionChangeToType:type allTypes:allTypes];
    }];

    [presentedSections addObject:@[]];

    [self setPresentedSectionCells:presentedSections];

    RecipientType *type = self.currency.defaultRecipientType;
    MCLog(@"Have %d fields", [type.fields count]);

    [self setRecipientType:type];

    NSArray *allTypes = [self.currency.recipientTypes array];
    [self handleSelectionChangeToType:type allTypes:allTypes];

    self.minimumFooterHeight = self.footer.frame.size.height;

    CGRect headerFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 40, 100);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerFrame];
    [headerLabel setNumberOfLines:0];
    [headerLabel setFont:[UIFont systemFontOfSize:14]];
    [headerLabel setTextColor:[UIColor mainTextColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [headerLabel setText:NSLocalizedString(@"refund.details.header.description", nil)];
    CGFloat fitHeight = [headerLabel sizeThatFits:CGSizeMake(CGRectGetWidth(headerFrame), CGFLOAT_MAX)].height;
    headerFrame.size.height = fitHeight;
    headerFrame.origin.x = 20;
    headerFrame.origin.y = TransferHeaderPaddingTop;
    [headerLabel setFrame:headerFrame];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(headerFrame) + TransferHeaderPaddingTop + TransferHeaderPaddingBottom)];
    [header setBackgroundColor:[UIColor clearColor]];
    [header addSubview:headerLabel];
    [self.tableView setTableHeaderView:header];

    [self.footerButton setTitle:NSLocalizedString(@"refund.details.footer.button.title", nil) forState:UIControlStateNormal];
    [self.footerButton addTarget:self action:@selector(continuePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.shown) {
        return;
    }

    [[AnalyticsCoordinator sharedInstance] refundDetailsScreenShown];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];


    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self.tableView setTableFooterView:self.footer];
        });
    };

    CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
    [self setExecutedOperation:currenciesOperation];
    [currenciesOperation setObjectModel:self.objectModel];
    [currenciesOperation setResultHandler:^(NSError *error) {
        if (error) {
            [hud hide];
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipient.types.load.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [[AnalyticsCoordinator sharedInstance] refundRecipientAdded];

        dataLoadCompletionBlock();
    }];

    [currenciesOperation execute];


    [self setShown:YES];
}

- (void)handleSelectionChangeToType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"handleSelectionChangeToType:%@", type.type);
    NSArray *cells = [self buildCellsForType:type allTypes:allTypes];
    [self setRecipientType:type];
    [self setRecipientTypeFieldCells:cells];
    [self setPresentedSectionCells:@[@[self.holderNameCell], cells]];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.presentedSectionCells count] - 1] withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(updateFooterSize) withObject:nil afterDelay:0.5];

}

- (void)updateFooterSize {
    [self.tableView adjustFooterViewSizeForMinimumHeight:self.minimumFooterHeight];
}

- (NSArray *)buildCellsForType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"Build cells for type:%@", type.type);
    NSMutableArray *result = [NSMutableArray array];
    if (allTypes.count > 1) {
        result = [NSMutableArray arrayWithCapacity:type.fields.count + 1];
        [self.transferTypeSelectionCell setSelectedType:type allTypes:allTypes];
        [result addObject:self.transferTypeSelectionCell];
    }

    for (RecipientTypeField *field in type.fields) {
        TextEntryCell *createdCell;
        if ([field.allowedValues count] > 0) {
            DropdownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWDropdownCellIdentifier];
            [cell setAllElements:[self.objectModel fetchedControllerForAllowedValuesOnField:field]];
            [cell configureWithTitle:field.title value:@""];
            [cell setType:field];
            [result addObject:cell];
            createdCell = cell;
        } else {
            RecipientFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
            [cell setFieldType:field];
            [result addObject:cell];
            createdCell = cell;
        }

        [createdCell setEditable:YES];
    }

    return [NSArray arrayWithArray:result];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"refund.details.account.details.section.header", nil);
    }
    return nil;
}

- (void)continuePressed {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];
    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"refund.details.save.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"refund.controller.validating.message", nil)];

    Recipient *recipient = [self.objectModel createRecipient];
    recipient.name = self.holderNameCell.value;
    recipient.currency = self.currency;
    recipient.type = self.recipientType;

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        NSString *value = [cell value];
        RecipientTypeField *field = cell.type;
        [recipient setValue:[field stripPossiblePatternFromValue:value] forField:field];
    }

    [self.payment setRefundRecipient:recipient];
    [self.objectModel saveContext];

    RecipientOperation *validate = [RecipientOperation validateOperationWithRecipient:recipient.objectID];
    [self setOperation:validate];
    [validate setObjectModel:self.objectModel];
    [validate setResponseHandler:^(NSError *error) {
        [self setOperation:nil];
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"refund.controller.validation.error.title", nil) error:error];
            [alertView show];
            return;
        }

        self.afterValidationBlock();
    }];
    [validate execute];
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];

    NSString *name = [self.holderNameCell value];
    if (![name hasValue]) {
        [issues appendIssue:NSLocalizedString(@"refund.controller.validation.error.empty.name", nil)];
    }

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        RecipientTypeField *field = cell.type;
        NSString *value = [cell value];

        NSString *valueIssue = [field hasIssueWithValue:value];
        if (![valueIssue hasValue]) {
            continue;
        }

        [issues appendIssue:valueIssue];
    }

    return [NSString stringWithString:issues];
}

@end
