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
#import "TextEntryCell.h"
#import "CurrencySelectionCell.h"
#import "RecipientFieldCell.h"
#import "NSString+Validation.h"
#import "Currency.h"
#import "TRWAlertView.h"
#import "RecipientProfileValidation.h"
#import "NSMutableString+Issues.h"
#import "UIApplication+Keyboard.h"
#import "UserRecipientsOperation.h"
#import "RecipientEntrySelectionCell.h"
#import "DropdownCell.h"
#import "ButtonCell.h"
#import "AddressBookUI/ABPeoplePickerNavigationController.h"
#import "ObjectModel.h"
#import "PhoneBookProfileSelector.h"
#import "PhoneBookProfile.h"
#import "Credentials.h"
#import "UITableView+FooterPositioning.h"
#import "TransferTypeSelectionCell.h"
#import "Recipient.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"
#import "ObjectModel+Currencies.h"
#import "ObjectModel+Users.h"
#import "RecipientTypeField.h"
#import "ObjectModel+Recipients.h"
#import "ObjectModel+PendingPayments.h"
#import "PendingPayment.h"
#import "ConfirmPaymentCell.h"
#import "ProfileSelectionView.h"
#import "UIView+Loading.h"
#import "ProfileSource.h"
#import "User.h"
#import "PersonalProfileSource.h"
#import "PersonalProfile.h"
#import "BusinessProfile.h"
#import "TransferBackButtonItem.h"
#import "GoogleAnalytics.h"
#import "NSError+TRWErrors.h"

static NSUInteger const kSenderSection = 0;
static NSUInteger const kRecipientSection = 1;
static NSUInteger const kCurrencySection = 2;
static NSUInteger const kRecipientFieldsSection = 3;

NSString *const kButtonCellIdentifier = @"kButtonCellIdentifier";

@interface RecipientViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) RecipientEntrySelectionCell *nameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UIButton *addButton;

@property (nonatomic, strong) Currency *currency;
@property (nonatomic, strong) RecipientType *recipientType;

@property (nonatomic, strong) Recipient *recipient;

@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

@property (nonatomic, strong) TransferTypeSelectionCell *transferTypeSelectionCell;

@property (nonatomic, strong) NSArray *presentedSections;
@property (nonatomic, assign) CGFloat minimumFooterHeight;
@property (nonatomic, assign) BOOL shown;

@property (nonatomic, strong) ConfirmPaymentCell *senderNameCell;
@property (nonatomic, strong) NSArray *senderCells;

@property (nonatomic, strong) ProfileSelectionView *profileSelectionView;

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
    if (IOS_7) {
        [self.tableView setSeparatorColor:[UIColor clearColor]];
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientEntrySelectionCell" bundle:nil] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:kButtonCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TransferTypeSelectionCell" bundle:nil] forCellReuseIdentifier:TWTypeSelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConfirmPaymentCell" bundle:nil] forCellReuseIdentifier:TWConfirmPaymentCellIdentifier];

    [self setProfileSelectionView:[ProfileSelectionView loadInstance]];
    [self presentProfileForSource:self.profileSelectionView.presentedSource];

    __block __weak RecipientViewController *weakSelf = self;
    [self.profileSelectionView setSelectionHandler:^(ProfileSource *selected) {
        [weakSelf presentProfileForSource:selected];
    }];


    [self setSenderNameCell:[self.tableView dequeueReusableCellWithIdentifier:TWConfirmPaymentCellIdentifier]];
    [self setSenderCells:@[self.senderNameCell]];



    RecipientEntrySelectionCell *nameCell = [self.tableView dequeueReusableCellWithIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [nameCell setSelectionHandler:^(Recipient *recipient) {
        [self didSelectRecipient:recipient];
    }];
    
    TextEntryCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    self.emailCell = emailCell;
    [emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.email", nil) value:@""];
  
    [self setRecipientCells:@[nameCell,emailCell]];
    

    NSMutableArray *currencyCells = [NSMutableArray array];

    CurrencySelectionCell *currencyCell = [self.tableView dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [self handleCurrencySelection:currency];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];

    self.transferTypeSelectionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTypeSelectionCellIdentifier];
    [self.transferTypeSelectionCell setSelectionChangeHandler:^(RecipientType *type, NSArray *allTypes) {
        [weakSelf handleSelectionChangeToType:type allTypes:allTypes];
    }];

    [self.addButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];

    if (self.preLoadRecipientsWithCurrency) {
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

    if (self.reportingType != RecipientReportingNone) {
        [[GoogleAnalytics sharedInstance] sendScreen:(self.reportingType == RecipientReportingNotLoggedIn ? @"Enter recipient details" : @"Enter recipient details 2")];
    }

    if (self.shown) {
        return;
    }

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    [self presentProfileForSource:self.profileSelectionView.presentedSource];

    [self setPresentedSectionCells:@[self.senderCells, self.recipientCells, self.currencyCells, @[]]];
    [self.tableView reloadData];

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

    if (self.preLoadRecipientsWithCurrency && [Credentials userLoggedIn]) {
        [self.nameCell setAutoCompleteRecipients:[self.objectModel fetchedControllerForRecipientsWithCurrency:self.preLoadRecipientsWithCurrency]];
    } else {
        [self.nameCell setAutoCompleteRecipients:nil];
    }

    [self.currencyCell setAllCurrencies:[self.objectModel fetchedControllerForAllCurrencies]];

    if (self.preLoadRecipientsWithCurrency) {
        [self handleCurrencySelection:self.preLoadRecipientsWithCurrency];
    }

    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self didSelectRecipient:self.recipient];
            [self.tableView setTableFooterView:self.footer];
        });
    };

    UserRecipientsOperation *recipientsOperation = nil;
    if (self.preLoadRecipientsWithCurrency && [Credentials userLoggedIn]) {
        recipientsOperation = [UserRecipientsOperation recipientsOperationWithCurrency:self.preLoadRecipientsWithCurrency];
        [recipientsOperation setObjectModel:self.objectModel];
        [recipientsOperation setResponseHandler:^(NSError *error) {
            if (error) {
                [hud hide];
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipients.preload.error.title", nil) error:error];
                [alertView show];
                return;
            }

            dataLoadCompletionBlock();
        }];
    }

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

        if (recipientsOperation) {
            [self setExecutedOperation:recipientsOperation];
            [recipientsOperation execute];
        } else {
            dataLoadCompletionBlock();
        }
    }];

    [currenciesOperation execute];

    [self setShown:YES];
}


- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    self.nameCell.value = profile.fullName;
}

- (void)didSelectRecipient:(Recipient *)recipient {
    [self setRecipient:recipient];
    [self handleSelectionChangeToType:recipient ? recipient.type : self.currency.defaultRecipientType allTypes:[self.currency.recipientTypes array]];

    if (!recipient) {
        [self.nameCell setValue:@""];
           [self.emailCell setValue:@""];
        [self.nameCell setEditable:YES];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setValue:@""];
            [fieldCell setEditable:YES];
        }
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"ExistingRecipientSelected"];
        [self.nameCell setValue:recipient.name];
        [self.emailCell setValue:recipient.email];
        [self.nameCell setEditable:NO];

        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
            [fieldCell setEditable:NO];
            if ([fieldCell isKindOfClass:[TransferTypeSelectionCell class]]) {
                continue;
            }

            RecipientTypeField *field = fieldCell.type;
            [fieldCell setValue:[recipient valueField:field]];
        }
    });
}

- (void)handleCurrencySelection:(Currency *)currency {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"CurrencyRecipientSelected" withLabel:currency.code];

        MCLog(@"Did select currency:%@. Default type:%@", currency.code, currency.defaultRecipientType.type);

        RecipientType *type = currency.defaultRecipientType;
        MCLog(@"Have %d fields", [type.fields count]);

        [self setCurrency:currency];
        [self setRecipientType:type];

        NSArray *allTypes = [currency.recipientTypes array];
        [self handleSelectionChangeToType:type allTypes:allTypes];
    });
}

- (void)handleSelectionChangeToType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"handleSelectionChangeToType:%@", type.type);
    NSArray *cells = [self buildCellsForType:type allTypes:allTypes];
    [self setRecipientType:type];
    [self setRecipientTypeFieldCells:cells];
    [self setPresentedSectionCells:@[self.senderCells, self.recipientCells, self.currencyCells, cells]];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self.presentedSections count] - 1] withRowAnimation:UITableViewRowAnimationNone];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (IBAction)addButtonPressed:(id)sender {
    [UIApplication dismissKeyboard];

    NSString *issues = [self validateInput];
    if ([issues hasValue]) {
        [[GoogleAnalytics sharedInstance] sendAlertEvent:@"SavingRecipientAlert" withLabel:issues];

        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"recipient.save.error.title", nil) message:issues];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    PendingPayment *payment = self.objectModel.pendingPayment;

    if (self.recipient) {
        self.recipient.email = self.emailCell.value;
        [payment setRecipient:self.recipient];
        [self.objectModel saveContext:self.afterSaveAction];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view]; 
    [hud setMessage:NSLocalizedString(@"recipient.controller.validating.message", nil)];

    Recipient *recipientInput = [self.objectModel createRecipient];
    recipientInput.name = self.nameCell.value;
    recipientInput.currency = self.currency;
    recipientInput.type = self.recipientType;
    recipientInput.email = self.emailCell.value;

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        NSString *value = [cell value];
        RecipientTypeField *field = cell.type;
        [recipientInput setValue:[field stripPossiblePatternFromValue:value] forField:field];
    }

    [payment setRecipient:recipientInput];
    [self.objectModel saveContext];

    [self.recipientValidation validateRecipient:recipientInput.objectID completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];

            if (error) {
                [[GoogleAnalytics sharedInstance] sendAlertEvent:@"SavingRecipientAlert" withLabel:[error localizedTransferwiseMessage]];

                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.validation.error.title", nil) error:error];
                [alertView show];
                return;
            }

            self.afterSaveAction();
        });
    }];
}

- (NSString *)validateInput {
    NSMutableString *issues = [NSMutableString string];

    NSString *name = [self.nameCell value];
    if (![name hasValue]) {
        [issues appendIssue:NSLocalizedString(@"recipient.controller.validation.error.empty.name", nil)];
    }
    
    NSString *email = self.emailCell.value;
    if ([email length]>0)
    {
        NSError *error = nil;
        // Sanity check email for the precence of at least an "@" and a "."
        // [Anything]@[Anything].[Anything]
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^.+@.+\\..+$" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSAssert(regex, @"Failed to create regular expresison");
        NSRange match = [regex rangeOfFirstMatchInString:email options:NSMatchingReportCompletion range:NSMakeRange(0, [email length])];
        if (match.location == NSNotFound)
        {
            [issues appendIssue:NSLocalizedString(@"recipient.controller.validation.error.email.format", nil)];
        }
    }

    for (RecipientFieldCell *cell in self.recipientTypeFieldCells) {
        if ([cell isKindOfClass:[TransferTypeSelectionCell class]]) {
            continue;
        }

        RecipientTypeField *field = cell.type;
        NSString *value = [cell value];

        NSString *valueIssue = [field hasIssueWithValue:value];
        if (![valueIssue hasValue]) {
            if([value length] < 1 && self.currency.recipientBicRequiredValue && [field.name caseInsensitiveCompare:@"bic"]== NSOrderedSame)
            {
                [issues appendIssue:[NSString stringWithFormat:NSLocalizedString(@"recipient.controller.validation.error.bic.required", nil),self.currency.code]];
            }
            continue;
        }

        [issues appendIssue:valueIssue];
    }

    return [NSString stringWithString:issues];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSNumber *sectionCode = self.presentedSections[(NSUInteger) section];
    switch ([sectionCode integerValue]) {
        case kSenderSection:
            return NSLocalizedString(@"recipient.controller.section.title.sender", nil);
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
    NSMutableArray *cells = [NSMutableArray arrayWithArray:presentedSectionCells];
    NSMutableArray *sectionIndexes = [NSMutableArray array];

    if (self.showMiniProfile) {
        [sectionIndexes addObject:@(kSenderSection)];
    } else {
        [cells removeObject:self.senderCells];
    }
    [sectionIndexes addObject:@(kRecipientSection)];

    if (self.preLoadRecipientsWithCurrency) {
        [cells removeObject:self.currencyCells];
    } else {
        [sectionIndexes addObject:@(kCurrencySection)];
    }

    [sectionIndexes addObject:@(kRecipientFieldsSection)];

    [super setPresentedSectionCells:cells];
    [self setPresentedSections:sectionIndexes];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSInteger sectionIndex = [self.presentedSections[section] integerValue];
    if (sectionIndex != kSenderSection) {
        return nil;
    }

    if (![self.objectModel.currentUser businessProfileFilled]) {
        return nil;
    }

    return self.profileSelectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSInteger sectionIndex = [self.presentedSections[section] integerValue];
    if (sectionIndex != kSenderSection) {
        return 0;
    }

    if (![self.objectModel.currentUser businessProfileFilled]) {
        return 0;
    }

    return CGRectGetHeight(self.profileSelectionView.frame);
}

- (void)presentProfileForSource:(ProfileSource *)source {
    User *user = [self.objectModel currentUser];
    NSString *name;
    UIImage *shownImage;
    PendingPayment *payment = [self.objectModel pendingPayment];
    if ([source isKindOfClass:[PersonalProfileSource class]]) {
        name = [user.personalProfile fullName];
        shownImage = [UIImage imageNamed:@"ProfileIcon.png"];
        [payment setProfileUsed:@"personal"];
    } else {
        name = [user.businessProfile name];
        shownImage = nil;
        [payment setProfileUsed:@"business"];
    }

    [self.objectModel saveContext];
    [self.senderNameCell.imageView setImage:shownImage];
    [self.senderNameCell.textLabel setText:name];
    [self.senderNameCell.detailTextLabel setText:@""];
    [self.tableView reloadData];
}

@end
