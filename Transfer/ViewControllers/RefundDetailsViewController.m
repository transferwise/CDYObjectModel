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
#import "TransferTypeSelectionHeader.h"
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
#import "UserRecipientsOperation.h"
#import "Credentials.h"
#import "RecipientEntrySelectionCell.h"

CGFloat const TransferHeaderPaddingTop = 40;
CGFloat const TransferHeaderPaddingBottom = 0;

@interface RefundDetailsViewController ()

@property (nonatomic, strong) RecipientEntrySelectionCell *holderNameCell;
@property (nonatomic, strong) TransferTypeSelectionHeader *transferTypeSelectionHeader;
@property (nonatomic, strong) RecipientType *recipientType;
@property (nonatomic, strong) NSArray *recipientTypeFieldCells;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) CGFloat minimumFooterHeight;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) TransferwiseOperation *operation;
@property (nonatomic, strong) Recipient *recipient;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

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

    [self.navigationItem setTitle:NSLocalizedString(@"refund.details.controller.title", nil)];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    [self.tableViews[0] registerNib:[RecipientEntrySelectionCell viewNib] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self.tableViews[0] registerNib:[DropdownCell viewNib] forCellReuseIdentifier:TWDropdownCellIdentifier];
    [self.tableViews[0] registerNib:[RecipientFieldCell viewNib] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];


    NSMutableArray *presentedSections = [NSMutableArray array];

    RecipientEntrySelectionCell *nameCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self setHolderNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameCell configureWithTitle:NSLocalizedString(@"refund.details.holders.name.label", nil) value:@""];
    [nameCell setSelectionHandler:^(Recipient *recipient) {
        [self didSelectRecipient:recipient];
    }];


    [presentedSections addObject:@[nameCell]];
    [presentedSections addObject:@[]];

    [self setSectionCellsByTableView:@[presentedSections]];

    [self.tableViews[0] reloadData];
    
    RecipientType *type = self.currency.defaultRecipientType;
    MCLog(@"Have %d fields", [type.fields count]);

    [self setRecipientType:type];

    NSArray *allTypes = [self.currency.recipientTypes array];
    [self handleSelectionChangeToType:type allTypes:allTypes];
    
    self.headerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"refund.details.header.description", nil),self.payment.recipient.name, self.payment.payOutStringWithCurrency];

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

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

//TODO: Rework with autoSuggestions instead
    /*
    if ([Credentials userLoggedIn]) {
        [self.holderNameCell setAutoCompleteRecipients:[self.objectModel fetchedControllerForRecipientsWithCurrency:self.currency]];
    } else {
        [self.holderNameCell setAutoCompleteRecipients:nil];
    }
*/
    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
        });
    };


    UserRecipientsOperation *recipientsOperation = nil;
    if ([Credentials userLoggedIn]) {
        recipientsOperation = [UserRecipientsOperation recipientsOperationWithCurrency:self.currency];
        [recipientsOperation setObjectModel:self.objectModel];
        [recipientsOperation setResponseHandler:^(NSError *error) {
            if (error) {
                [hud hide];
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"refund.controller.existing.recipients.preload.error.title", nil) error:error];
                [alertView show];
                return;
            }

            dataLoadCompletionBlock();
        }];
    }

    if (recipientsOperation) {
        [recipientsOperation execute];
    } else {
        dataLoadCompletionBlock();
    }

    [self setShown:YES];
}

- (void)handleSelectionChangeToType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"handleSelectionChangeToType:%@", type.type);
    NSArray *cells = [self buildCellsForType:type allTypes:allTypes];
    [self setRecipientType:type];
    [self setRecipientTypeFieldCells:cells];
    [self setSectionCellsByTableView:@[@[@[self.holderNameCell], cells]]];

    [self.tableViews[0] reloadSections:[NSIndexSet indexSetWithIndex:[self.sectionCellsByTableView[0] count] - 1] withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(updateFooterSize) withObject:nil afterDelay:0.5];

}

- (void)updateFooterSize {
    [self.tableViews[0] adjustFooterViewSizeForMinimumHeight:self.minimumFooterHeight];
}

- (NSArray *)buildCellsForType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"Build cells for type:%@", type.type);
    NSMutableArray *result = [NSMutableArray array];
    if (allTypes.count > 1) {
        if (allTypes.count > 1) {
            TransferTypeSelectionHeader* tabbedHeader = [[NSBundle mainBundle] loadNibNamed:@"TransferTypeSelectionHeaderNoTitle" owner:self options:nil][0];
            __weak typeof(self) weakSelf = self;
            [ tabbedHeader setSelectionChangeHandler:^(RecipientType *type, NSArray *allTypes) {
                [weakSelf handleSelectionChangeToType:type allTypes:allTypes];
            }];
            [tabbedHeader setSelectedType:type allTypes:allTypes];
            self.transferTypeSelectionHeader = tabbedHeader;
        }
        else
        {
            self.transferTypeSelectionHeader = nil;
        }

    }

    for (RecipientTypeField *field in type.fields) {
        TextEntryCell *createdCell;
        if ([field.allowedValues count] > 0) {
            DropdownCell *cell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TWDropdownCellIdentifier];
            [cell setAllElements:[self.objectModel fetchedControllerForAllowedValuesOnField:field]];
            [cell configureWithTitle:field.title value:@""];
            [cell setType:field];
            [result addObject:cell];
            createdCell = cell;
        } else {
            RecipientFieldCell *cell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
            [cell setFieldType:field];
            [result addObject:cell];
            createdCell = cell;
        }

        [createdCell setEditable:YES];
    }

    return [NSArray arrayWithArray:result];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.transferTypeSelectionHeader.frame.size.height;
    }
    else
    {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.transferTypeSelectionHeader;
    }
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == self.tableViews[0])
    {
        if (section == 0) {
            return NSLocalizedString(@"refund.details.account.details.section.header", nil);
        }
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
        if ([cell isKindOfClass:[TransferTypeSelectionHeader class]]) {
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

        [[AnalyticsCoordinator sharedInstance] refundRecipientAdded];
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
        if ([cell isKindOfClass:[TransferTypeSelectionHeader class]]) {
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

- (void)didSelectRecipient:(Recipient *)recipient {
    [self setRecipient:recipient];
    [self handleSelectionChangeToType:recipient ? recipient.type : self.currency.defaultRecipientType allTypes:[self.currency.recipientTypes array]];

    if (!recipient) {
        [self.holderNameCell setValue:@""];
        [self.holderNameCell setEditable:YES];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setValue:@""];
            [fieldCell setEditable:YES];
        }
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.holderNameCell setValue:recipient.name];
        [self.holderNameCell setEditable:NO];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setEditable:NO];
            if ([fieldCell isKindOfClass:[TransferTypeSelectionHeader class]]) {
                continue;
            }

            RecipientTypeField *field = fieldCell.type;
            [fieldCell setValue:[recipient valueField:field]];
        }
    });
}

@end
