//
//  RecipientViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientViewController.h"
#import "UIColor+Theme.h"
#import "TRWProgressHUD.h"
#import "TransferwiseOperation.h"
#import "CurrenciesOperation.h"
#import "RecipientTypesOperation.h"
#import "TextEntryCell.h"
#import "CurrencySelectionCell.h"
#import "Constants.h"
#import "Currency.h"
#import "RecipientType.h"
#import "RecipientTypeField.h"
#import "RecipientFieldCell.h"
#import "NSString+Validation.h"
#import "TRWAlertView.h"
#import "NSMutableString+Issues.h"
#import "CreateRecipientOperation.h"
#import "UIApplication+Keyboard.h"
#import "RecipientSectionHeaderView.h"
#import "UIView+Loading.h"

static NSUInteger const kRecipientSection = 0;
static NSUInteger const kCurrencySection = 1;
static NSUInteger const kRecipientFieldsSection = 2;

@interface RecipientViewController ()

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) TextEntryCell *nameCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UIButton *addButton;

@property (nonatomic, strong) Currency *selectedCurrency;
@property (nonatomic, strong) RecipientType *selectedRecipientType;

@property (nonatomic, strong) RecipientSectionHeaderView *recipientSectionHeader;
@property (nonatomic, strong) RecipientSectionHeaderView *currencySectionHeader;
@property (nonatomic, strong) RecipientSectionHeaderView *fieldsSectionHeader;

- (IBAction)addButtonPressed:(id)sender;

@end

@implementation RecipientViewController

- (id)init {
    self = [super initWithNibName:@"RecipientViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];

    NSMutableArray *recipientCells = [NSMutableArray array];

    TextEntryCell *nameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [recipientCells addObject:nameCell];

    [self setRecipientCells:recipientCells];

    NSMutableArray *currencyCells = [NSMutableArray array];

    CurrencySelectionCell *currencyCell = [self.tableView dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [self handleCurrencySelection:currency];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];

    [self.addButton setTitle:NSLocalizedString(@"recipient.controller.add.button.title", nil) forState:UIControlStateNormal];

    [self setRecipientSectionHeader:[RecipientSectionHeaderView loadInstance]];
    [self.recipientSectionHeader setText:NSLocalizedString(@"recipient.controller.section.title.recipient", nil)];

    [self setCurrencySectionHeader:[RecipientSectionHeaderView loadInstance]];
    [self.currencySectionHeader setText:NSLocalizedString(@"recipient.controller.section.title.currency", nil)];

    [self setFieldsSectionHeader:[RecipientSectionHeaderView loadInstance]];
    [self.fieldsSectionHeader setText:NSLocalizedString(@"recipient.controller.section.title.type.fields", nil)];

    __block __weak RecipientViewController *weakSelf = self;
    [self.fieldsSectionHeader setSelectionChangeHandler:^(RecipientType *type) {
        [weakSelf handleSelectionChangeToType:type];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"recipient.controller.title", nil)];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

    CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
    [self setExecutedOperation:currenciesOperation];
    [currenciesOperation setResultHandler:^(NSArray *currencies, NSError *error) {
        if (error) {
            [hud hide];
            return;
        }

        RecipientTypesOperation *operation = [RecipientTypesOperation operation];
        [self setExecutedOperation:operation];

        [operation setResultHandler:^(NSArray *recipients, NSError *typesError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];

                if (typesError) {
                    return;
                }

                [self.currencyCell setAllCurrencies:currencies];
                [self setRecipientTypes:recipients];

                [self setPresentedSectionCells:@[self.recipientCells, self.currencyCells, @[]]];
                [self.tableView setTableFooterView:self.footer];
                [self.tableView reloadData];
            });
        }];

        [operation execute];
    }];

    [currenciesOperation execute];
}

- (void)handleCurrencySelection:(Currency *)currency {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did select currency:%@. Default type:%@", currency, currency.defaultRecipientType);

        RecipientType *type = [self findTypeWithCode:currency.defaultRecipientType];
        MCLog(@"Have %d fields", [type.fields count]);

        [self setSelectedCurrency:currency];
        [self setSelectedRecipientType:type];

        NSArray *allTypes = [self findAllTypesWithCodes:currency.recipientTypes];
        [self.fieldsSectionHeader setSelectedType:type allTypes:allTypes];

        [self handleSelectionChangeToType:type];
    });
}

- (void)handleSelectionChangeToType:(RecipientType *)type {
    NSArray *cells = [self buildCellsForType:type];
    [self setRecipientTypeFieldCells:cells];
    [self setPresentedSectionCells:@[self.recipientCells, self.currencyCells, cells]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kRecipientFieldsSection] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray *)findAllTypesWithCodes:(NSArray *)codes {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[codes count]];
    for (NSString *code in codes) {
        RecipientType *type = [self findTypeWithCode:code];
        if (!code) {
            MCLog(@"Did not find type for code %@", code);
            continue;
        }

        [result addObject:type];
    }

    return [NSArray arrayWithArray:result];
}

- (NSArray *)buildCellsForType:(RecipientType *)type {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[type.fields count]];
    for (RecipientTypeField *field in type.fields) {
        RecipientFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
        [cell setFieldType:field];
        [result addObject:cell];
    }
    return [NSArray arrayWithArray:result];
}

- (RecipientType *)findTypeWithCode:(NSString *)typeString {
    for (RecipientType *type in self.recipientTypes) {
        if (![typeString isEqualToString:type.type]) {
            continue;
        }

        return type;
    }
    return nil;
}

- (IBAction)addButtonPressed:(id)sender {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];
    if ([issues hasValue]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"recipient.save.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = [self.nameCell value];
    data[@"currency"] = [self.selectedCurrency code];
    data[@"type"] = [self.selectedRecipientType type];
    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        NSString *value = [cell value];
        NSString *field = [cell.type name];
        data[field] = value;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.creating.message", nil)];

    CreateRecipientOperation *operation = [CreateRecipientOperation operationWithData:data];
    [self setExecutedOperation:operation];
    [operation setResponseHandler:^(Recipient *recipient, NSError *error) {
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.save.error.title", nil) error:error];
            [alertView show];
            return;
        }

        [self.navigationController popViewControllerAnimated:YES];
    }];

    [operation execute];
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];

    NSString *name = [self.nameCell value];
    if (![name hasValue]) {
        [issues appendIssue:NSLocalizedString(@"recipient.controller.validation.error.empty.name", nil)];
    }

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        NSString *value = [cell value];
        if ([value hasValue]) {
            continue;
        }

        [issues appendIssue:[NSString stringWithFormat:NSLocalizedString(@"recipient.controller.validation.error.field.empty", nil), cell.type.title]];
    }

    return [NSString stringWithString:issues];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kRecipientSection:
            return self.recipientSectionHeader;
        case kCurrencySection:
            return self.currencySectionHeader;
        case kRecipientFieldsSection:
            return self.fieldsSectionHeader;
        default:
            MCLog(@"Unhandled section:%d", section);
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGRectGetHeight(self.recipientSectionHeader.frame);
}

@end