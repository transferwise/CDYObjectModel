//
//  RecipientViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "RecipientViewController.h"
#import "UIColor+Theme.h"
#import "TRWProgressHUD.h"
#import "TransferwiseOperation.h"
#import "CurrenciesOperation.h"
#import "RecipientTypesOperation.h"
#import "TextEntryCell.h"
#import "CurrencySelectionCell.h"
#import "PlainCurrency.h"
#import "PlainRecipientType.h"
#import "PlainRecipientTypeField.h"
#import "RecipientFieldCell.h"
#import "NSString+Validation.h"
#import "PlainRecipient.h"
#import "TRWAlertView.h"
#import "NSMutableString+Issues.h"
#import "UIApplication+Keyboard.h"
#import "RecipientProfileValidation.h"
#import "UserRecipientsOperation.h"
#import "RecipientEntrySelectionCell.h"
#import "DropdownCell.h"
#import "ButtonCell.h"
#import "AddressBookUI/ABPeoplePickerNavigationController.h"
#import "ObjectModel.h"
#import "PhoneBookProfileSelector.h"
#import "PhoneBookProfile.h"
#import "Credentials.h"
#import "PlainRecipientProfileInput.h"
#import "UITableView+FooterPositioning.h"
#import "TransferTypeSelectionCell.h"
#import "ObjectModel+Recipients.h"
#import "Recipient.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"
#import "ObjectModel+Currencies.h"
#import "Currency.h"

static NSUInteger const kImportSection = 0;
static NSUInteger const kRecipientSection = 1;
static NSUInteger const kCurrencySection = 2;
static NSUInteger const kRecipientFieldsSection = 3;

NSString *const kButtonCellIdentifier = @"kButtonCellIdentifier";

@interface RecipientViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) ButtonCell *importCell;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) RecipientEntrySelectionCell *nameCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypes;
@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UIButton *addButton;

@property (nonatomic, strong) PlainCurrency *selectedCurrency;
@property (nonatomic, strong) PlainRecipientType *selectedRecipientType;

@property (nonatomic, strong) NSArray *recipientsForCurrency;
@property (nonatomic, strong) PlainRecipient *selectedRecipient;

@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

@property (nonatomic, strong) TransferTypeSelectionCell *transferTypeSelectionCell;

@property (nonatomic, strong) NSArray *presentedSections;
@property CGFloat minimumFooterHeight;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientEntrySelectionCell" bundle:nil] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:kButtonCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TransferTypeSelectionCell" bundle:nil] forCellReuseIdentifier:TWTypeSelectionCellIdentifier];

    self.importCell = [self.tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
    [self.importCell.textLabel setText:NSLocalizedString(@"recipient.import.from.phonebook.label", nil)];

    NSMutableArray *recipientCells = [NSMutableArray array];

    RecipientEntrySelectionCell *nameCell = [self.tableView dequeueReusableCellWithIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [nameCell setSelectionHandler:^(PlainRecipient *recipient) {
        [self didSelectRecipient:recipient];
    }];
    [recipientCells addObject:nameCell];

    [self setRecipientCells:recipientCells];

    NSMutableArray *currencyCells = [NSMutableArray array];

    CurrencySelectionCell *currencyCell = [self.tableView dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [self handleCurrencySelection:[currency plainCurrency]];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];

    __block __weak RecipientViewController *weakSelf = self;
    
    self.transferTypeSelectionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTypeSelectionCellIdentifier];
    [self.transferTypeSelectionCell setSelectionChangeHandler:^(PlainRecipientType *type) {
        [weakSelf handleSelectionChangeToType:type];
    }];

    [self.addButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];

    if (self.preloadRecipientsWithCurrency) {
        [self.currencyCell setEditable:NO];
    }
    
    self.minimumFooterHeight = self.footer.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self.recipientTypes count] != 0) {
        return;
    }

    [self setPresentedSectionCells:@[@[self.importCell], self.recipientCells, self.currencyCells, @[]]];
    [self.tableView setTableFooterView:self.footer];
    [self.tableView reloadData];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

    [self.currencyCell setAllCurrencies:[self.objectModel fetchedControllerForAllCurrencies]];

    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self.nameCell setAutoCompleteRecipients:self.recipientsForCurrency];
            [self setPresentedSectionCells:@[@[self.importCell], self.recipientCells, self.currencyCells, @[]]];
            [self.tableView setTableFooterView:self.footer];
            [self.tableView reloadData];
            [self didSelectRecipient:self.selectedRecipient];
        });
    };

    UserRecipientsOperation *recipientsOperation = nil;
    if (self.preloadRecipientsWithCurrency && [Credentials userLoggedIn]) {
        recipientsOperation = [UserRecipientsOperation recipientsOperationWithCurrency:self.preloadRecipientsWithCurrency];
        [recipientsOperation setObjectModel:self.objectModel];
        [recipientsOperation setResponseHandler:^(NSError *error) {
            if (error) {
                [hud hide];
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipients.preload.error.title", nil) error:error];
                [alertView show];
                return;
            }

            NSArray *recipientObjects = [self.objectModel recipientsWithCurrency:self.preloadRecipientsWithCurrency.code];
            NSArray *recipients = [Recipient createPlainRecipients:recipientObjects];
            MCLog(@"Loaded %d recipients for %@", [recipients count], self.preloadRecipientsWithCurrency.code);
            [self setRecipientsForCurrency:recipients];
            dataLoadCompletionBlock();
        }];
    }

    RecipientTypesOperation *typesOperation = [RecipientTypesOperation operation];
    [typesOperation setObjectModel:self.objectModel];
    [typesOperation setResultHandler:^(NSError *typesError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (typesError) {
                [hud hide];
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipient.types.load.error.title", nil) error:typesError];
                [alertView show];
                return;
            }

            NSArray *types = [self.objectModel listAllRecipientTypes];
            NSArray *recipients = [RecipientType createPlainTypes:types];

            [self setRecipientTypes:recipients];

            if (recipientsOperation) {
                [self setExecutedOperation:recipientsOperation];
                [recipientsOperation execute];
            } else {
                dataLoadCompletionBlock();
            }
        });
    }];

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

        [self setExecutedOperation:typesOperation];
        [typesOperation execute];
    }];

    [currenciesOperation execute];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != kImportSection) {
        return;
    }

    PhoneBookProfileSelector *selector = [[PhoneBookProfileSelector alloc] init];
    [self setProfileSelector:selector];
    [selector presentOnController:self completionHandler:^(PhoneBookProfile *profile) {
        [self loadDataFromProfile:profile];
    }];
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    self.nameCell.value = profile.fullName;
}

- (void)didSelectRecipient:(PlainRecipient *)recipient {
    [self setSelectedRecipient:recipient];
    [self handleSelectionChangeToType:recipient ? [self findTypeWithCode:recipient.type] : [self findTypeWithCode:self.selectedCurrency.defaultRecipientType]];

    if (!recipient) {
        [self.nameCell setValue:@""];
        [self.nameCell setEditable:YES];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setValue:@""];
            [fieldCell setEditable:YES];
        }
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.nameCell setValue:recipient.name];
        [self.nameCell setEditable:NO];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setEditable:NO];

            if ([fieldCell isKindOfClass:[TransferTypeSelectionCell class]]) {
                [self.transferTypeSelectionCell setSelectedType:[self findTypeWithCode:recipient.type] allTypes:[self findAllTypesWithCodes:self.selectedCurrency.recipientTypes]];
                continue;
            }

            if ([fieldCell isKindOfClass:[DropdownCell class]]) {
                [fieldCell setValue:recipient.usState];
                continue;
            }

            PlainRecipientTypeField *field = fieldCell.type;
            [fieldCell setValue:[recipient valueForKeyPath:field.name]];
        }
    });
}

- (void)handleCurrencySelection:(PlainCurrency *)currency {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did select currency:%@. Default type:%@", currency, currency.defaultRecipientType);

        PlainRecipientType *type = [self findTypeWithCode:currency.defaultRecipientType];
        MCLog(@"Have %d fields", [type.fields count]);

        [self setSelectedCurrency:currency];
        [self setSelectedRecipientType:type];

        //NSArray *allTypes = [self findAllTypesWithCodes:currency.recipientTypes];
        //[self.fieldsSectionHeader setSelectedType:type allTypes:allTypes];

        [self handleSelectionChangeToType:type];
    });
}

- (void)handleSelectionChangeToType:(PlainRecipientType *)type {
    MCLog(@"handleSelectionChangeToType:%@", type.type);
    NSArray *cells = [self buildCellsForType:type];
    [self setSelectedRecipientType:type];
    [self setRecipientTypeFieldCells:cells];
    [self setPresentedSectionCells:@[@[self.importCell], self.recipientCells, self.currencyCells, cells]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.presentedSections count] - 1] withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(updateFooterSize) withObject:nil afterDelay:0.5];

}

- (void)updateFooterSize
{
    [self.tableView adjustFooterViewSizeForMinimumHeight:self.minimumFooterHeight];
}

- (NSArray *)findAllTypesWithCodes:(NSArray *)codes {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *code in codes) {
        PlainRecipientType *type = [self findTypeWithCode:code];
        if (!type) {
            MCLog(@"Did not find type for code %@", code);
            continue;
        }

        [result addObject:type];
    }

    return [NSArray arrayWithArray:result];
}

- (NSArray *)buildCellsForType:(PlainRecipientType *)type {
    MCLog(@"Build cells");
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[type.fields count]];
    NSArray *allTypes = [self findAllTypesWithCodes:self.selectedCurrency.recipientTypes];
    if (allTypes.count > 1) {
        result = [NSMutableArray arrayWithCapacity:type.fields.count + 1];
        [self.transferTypeSelectionCell setSelectedType:type allTypes:allTypes];
        [result addObject:self.transferTypeSelectionCell];
    }
    for (PlainRecipientTypeField *field in type.fields) {
        //TODO jaanus: make this more generic
        if ([field.name isEqualToString:@"usState"]) {
            DropdownCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWDropdownCellIdentifier];
            [cell setAllElements:field.possibleValues];
            [cell configureWithTitle:field.title value:@""];
            [result addObject:cell];
        } else {
            RecipientFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
            [cell setFieldType:field];
            [result addObject:cell];
        }
    }
    return [NSArray arrayWithArray:result];
}

- (PlainRecipientType *)findTypeWithCode:(NSString *)typeString {
    for (PlainRecipientType *type in self.recipientTypes) {
        if (![typeString isEqualToString:type.type]) {
            continue;
        }

        return type;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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

    if (self.selectedRecipient) {
        self.afterSaveAction();
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.validating.message", nil)];

    PlainRecipientProfileInput *recipientInput = [[PlainRecipientProfileInput alloc] init];
    recipientInput.name = self.nameCell.value;
    recipientInput.currency = self.selectedCurrency.code;
    recipientInput.type = self.selectedRecipientType.type;

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        if ([cell isKindOfClass:[DropdownCell class]]) {
            recipientInput.usState = cell.value;
            continue;
        }

        NSString *value = [cell value];
        NSString *field = [cell.type name];
        [recipientInput setValue:value forKeyPath:field];
    }

    [self.recipientValidation validateRecipient:recipientInput completion:^(PlainRecipient *recipient, NSError *error) {
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.validation.error.title", nil) error:error];
            [alertView show];
            return;
        }

        self.afterSaveAction();
    }];
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];

    NSString *name = [self.nameCell value];
    if (![name hasValue]) {
        [issues appendIssue:NSLocalizedString(@"recipient.controller.validation.error.empty.name", nil)];
    }

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        NSString *value = [cell value];
        if ([value hasValue]) {
            continue;
        }

        [issues appendIssue:[NSString stringWithFormat:NSLocalizedString(@"recipient.controller.validation.error.field.empty", nil), cell.type.title]];
    }

    return [NSString stringWithString:issues];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSNumber *sectionCode = self.presentedSections[(NSUInteger) section];
    switch ([sectionCode integerValue]) {
        case kImportSection:
            return nil;
        case kRecipientSection:
            return NSLocalizedString(@"recipient.controller.section.title.recipient", nil);
        case kCurrencySection:
            return NSLocalizedString(@"recipient.controller.section.title.currency", nil);
        case kRecipientFieldsSection:
            return NSLocalizedString(@"recipient.controller.section.title.type.fields", nil);
        default:
            MCLog(@"Unhandled section:%d", section);
            return nil;
    }
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return YES;
}

- (void)setPresentedSectionCells:(NSArray *)presentedSectionCells {
    if (!self.preloadRecipientsWithCurrency) {
        [self setPresentedSections:@[@(kImportSection), @(kRecipientSection), @(kCurrencySection), @(kRecipientFieldsSection)]];
        [super setPresentedSectionCells:presentedSectionCells];
        return;
    }

    [self setPresentedSections:@[@(kImportSection), @(kRecipientSection), @(kRecipientFieldsSection)]];
    NSMutableArray *cells = [NSMutableArray arrayWithArray:presentedSectionCells];
    [cells removeObject:self.currencyCells];
    [super setPresentedSectionCells:cells];
}

@end
