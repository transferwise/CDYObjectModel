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
#import "TransferTypeSelectionHeader.h"
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
#import "TextFieldSuggestionTable.h"
#import "NameSuggestionCellProvider.h"
#import "NameLookupWrapper.h"
#import "MOMStyle.h"
#import "UIView+RenderBlur.h"
#import "UIResponder+FirstResponder.h"

static NSUInteger const kRecipientSection = 0;
static NSUInteger const kCurrencySection = 1;
static NSUInteger const kRecipientFieldsSection = 2;

NSString *const kButtonCellIdentifier = @"kButtonCellIdentifier";

@interface RecipientViewController () <ABPeoplePickerNavigationControllerDelegate, SuggestionTableDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) ButtonCell *importCell;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) RecipientEntrySelectionCell *nameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@property (nonatomic, strong) IBOutlet UIButton *addButton;

@property (nonatomic, strong) Currency *currency;
@property (nonatomic, strong) RecipientType *recipientType;

@property (nonatomic, strong) Recipient *recipient;

@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

@property (nonatomic, strong) DataEntryDefaultHeader *recipientFieldsHeader;

@property (nonatomic, strong) NSArray *presentedSectionsByTableView;
@property (nonatomic, assign) CGFloat minimumFooterHeight;
@property (nonatomic, assign) BOOL shown;


@property (nonatomic, strong) IBOutlet TextFieldSuggestionTable* suggestionTable;
@property (nonatomic, strong) NameSuggestionCellProvider *cellProvider;
@property (nonatomic, strong) PhoneBookProfile *lastSelectedProfile;

@property (nonatomic, assign) CGFloat cellHeight;


// iPad
@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstColumnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondColumnLeftEdgeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLeftMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewRightMargin;

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

    for (UITableView* tableView in self.tableViews)
    {
        [self setupTableView:tableView];
    }

    
    self.cellHeight = IPAD ? 70.0f : 60.0f;
    
    RecipientEntrySelectionCell *nameCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [nameCell setSelectionHandler:^(Recipient *recipient) {
        [self didSelectRecipient:recipient];
    }];
    
    TextEntryCell *emailCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    self.emailCell = emailCell;
    [emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.email", nil) value:@""];
    

    [self setRecipientCells:@[nameCell,emailCell]];

    NSMutableArray *currencyCells = [NSMutableArray array];
    
    UITableView *secondColumn = [self hasMoreThanOneTableView]?self.tableViews[1]:self.tableViews[0];
    CurrencySelectionCell *currencyCell = [secondColumn dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [self handleCurrencySelection:currency];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];

    [self.addButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];

    if (self.preLoadRecipientsWithCurrency) {
        [self.currencyCell setEditable:NO];
    }
    
    self.cellProvider = [[NameSuggestionCellProvider alloc] init];
    
    self.suggestionTable = [[NSBundle mainBundle] loadNibNamed:@"TextFieldSuggestionTable" owner:self options:nil][0];
    self.suggestionTable.rowHeight = self.cellHeight;
    self.suggestionTable.hidden = YES;
    self.suggestionTable.suggestionTableDelegate = self;
    [self.view addSubview:self.suggestionTable];
    self.suggestionTable.textField = nameCell.entryField;
    self.suggestionTable.dataSource = self.cellProvider;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self configureForInterfaceOrientation:toInterfaceOrientation];
    self.suggestionTable.alpha = 0.0f;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self suggestionTableDidStartEditing:self.suggestionTable];
    self.suggestionTable.alpha = 1.0f;
}

-(void)configureForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        self.scrollViewLeftMargin.constant = 204.0f;
        self.scrollViewRightMargin.constant = 204.0f;
        
        self.secondColumnLeftEdgeConstraint.constant = -360;
        self.secondColumnTopConstraint.constant = self.firstColumnHeightConstraint.constant;
    }
    else
    {
        self.scrollViewLeftMargin.constant = 100.0f;
        self.scrollViewRightMargin.constant = 100.0f;
        self.secondColumnLeftEdgeConstraint.constant = 100.0f;
        self.secondColumnTopConstraint.constant = 0.0f;
    }
}

-(void)setupTableView:(UITableView*)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"RecipientEntrySelectionCell" bundle:nil] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
    
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    if([self hasMoreThanOneTableView])
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells], @[self.currencyCells, @[]]]];
    }
    else
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells, self.currencyCells, @[]]]];
    }
    [self.tableViews makeObjectsPerformSelector:@selector(reloadData)];
    [self refreshTableViewSizes];
    
    [self configureForInterfaceOrientation:self.interfaceOrientation];

    

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];

    if (self.preLoadRecipientsWithCurrency && [Credentials userLoggedIn]) {
        [self.cellProvider setAutoCompleteRecipients:[self.objectModel fetchedControllerForRecipientsWithCurrency:self.preLoadRecipientsWithCurrency]];
    }

    [self.currencyCell setAllCurrencies:[self.objectModel fetchedControllerForAllCurrencies]];

    if (self.preLoadRecipientsWithCurrency) {
        [self handleCurrencySelection:self.preLoadRecipientsWithCurrency];
    }

    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self didSelectRecipient:self.recipient];
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
    [self didSelectRecipient:nil];
    self.lastSelectedProfile = profile;
    self.nameCell.value = profile.fullName;
    self.emailCell.value = profile.email;
    
    __weak typeof(self) weakSelf = self;
    [profile loadThumbnail:^(PhoneBookProfile* profile, UIImage *image) {
        if ([weakSelf.lastSelectedProfile isEqual:profile])
        {
            weakSelf.nameCell.thumbnailImage.image = image;
        }
    }];
    
}

- (void)didSelectRecipient:(Recipient *)recipient {
    [self setRecipient:recipient];
    [self handleSelectionChangeToType:recipient ? recipient.type : self.currency.defaultRecipientType allTypes:[self.currency.recipientTypes array]];

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
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"ExistingRecipientSelected"];
        [self.nameCell setValue:recipient.name];
        [self.emailCell setValue:recipient.email];

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
    if([self hasMoreThanOneTableView])
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells], @[self.currencyCells, cells]]];
    }
    else
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells, self.currencyCells, cells]]];
    }

    
    if([self hasMoreThanOneTableView])
    {
        [self.tableViews[1] reloadSections:[NSIndexSet indexSetWithIndex:[self.presentedSectionsByTableView[1] count] - 1 ] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [self.tableViews[0] reloadSections:[NSIndexSet indexSetWithIndex:[self.presentedSectionsByTableView[0] count] - 1 ] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self refreshTableViewSizes];

}


- (NSArray *)buildCellsForType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"Build cells for type:%@", type.type);
    NSMutableArray *result = [NSMutableArray array];

    //Set up a tabbed or non tabbed header depending on number of types
    if (allTypes.count > 1) {
        TransferTypeSelectionHeader* tabbedHeader = [[NSBundle mainBundle] loadNibNamed:@"TransferTypeSelectionHeader" owner:self options:nil][0];
        __weak typeof(self) weakSelf = self;
        [ tabbedHeader setSelectionChangeHandler:^(RecipientType *type, NSArray *allTypes) {
            [weakSelf handleSelectionChangeToType:type allTypes:allTypes];
        }];
        [tabbedHeader setSelectedType:type allTypes:allTypes];
        self.recipientFieldsHeader = tabbedHeader;
    }
    else
    {
        self.recipientFieldsHeader = [[NSBundle mainBundle] loadNibNamed:@"DataEntryDefaultHeader" owner:self options:nil][0];
    }
    
    self.recipientFieldsHeader.titleLabel.text =  NSLocalizedString(@"recipient.controller.section.title.type.fields", nil);

    //Generate cells
    
    UITableView* tableView = [self hasMoreThanOneTableView]?self.tableViews[1]:self.tableViews[0];
    for (RecipientTypeField *field in type.fields) {
        TextEntryCell *createdCell;
        if ([field.allowedValues count] > 0) {
            DropdownCell *cell = [tableView dequeueReusableCellWithIdentifier:TWDropdownCellIdentifier];
            [cell setAllElements:[self.objectModel fetchedControllerForAllowedValuesOnField:field]];
            [cell configureWithTitle:field.title value:@""];
            [cell setType:field];
            [result addObject:cell];
            createdCell = cell;
        } else {
            RecipientFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
            [cell setFieldType:field];
            [result addObject:cell];
            createdCell = cell;
        }

        [createdCell setEditable:YES];
    }

    return [NSArray arrayWithArray:result];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
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
        if ([cell isKindOfClass:[TransferTypeSelectionHeader class]]) {
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






-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    if ([self.presentedSectionsByTableView[index][section] integerValue] == kRecipientFieldsSection)
    {
        return self.recipientFieldsHeader.frame.size.height;
    }
    
    return [super tableView:tableView heightForHeaderInSection:section];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     NSUInteger index = [self.tableViews indexOfObject:tableView];
    if ([self.presentedSectionsByTableView[index][section] integerValue] == kRecipientFieldsSection)
    {
        return self.recipientFieldsHeader;
    }
    
    return [super tableView:tableView viewForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    NSUInteger index = [self.tableViews indexOfObject:tableView];
    NSNumber *sectionCode = self.presentedSectionsByTableView[index][(NSUInteger) section];
    switch ([sectionCode integerValue]) {
        case kRecipientSection:
            return IPAD?NSLocalizedString(@"recipient.controller.section.title.ipad.recipient", nil):nil;
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

- (void)setSectionCellsByTableView:(NSArray*)sectionCellsByTableView
{
    NSMutableArray* finalSectionCellsByTableView = [sectionCellsByTableView mutableCopy];
    NSMutableArray* finalPresentedSectionsByTableView = [NSMutableArray array];
    if([self hasMoreThanOneTableView])
    {
        [finalPresentedSectionsByTableView addObject:@[@(kRecipientSection)]];
        
        NSMutableArray *cells = [sectionCellsByTableView[1] mutableCopy];
        NSMutableArray *sectionIndexes = [NSMutableArray array];
        
        if (self.preLoadRecipientsWithCurrency) {
            [cells removeObject:self.currencyCells];
        } else {
            [sectionIndexes addObject:@(kCurrencySection)];
        }
        
        finalSectionCellsByTableView[1] = cells;
        
        [sectionIndexes addObject:@(kRecipientFieldsSection)];
        
        [finalPresentedSectionsByTableView addObject:sectionIndexes];
    }
    else
    {
        NSMutableArray *cells = [sectionCellsByTableView[0] mutableCopy];
        NSMutableArray *sectionIndexes = [NSMutableArray array];
        [sectionIndexes addObject:@(kRecipientSection)];
        
        if (self.preLoadRecipientsWithCurrency) {
            [cells removeObject:self.currencyCells];
        } else {
            [sectionIndexes addObject:@(kCurrencySection)];
        }
        
        finalSectionCellsByTableView[0] = cells;
        
        [sectionIndexes addObject:@(kRecipientFieldsSection)];
        
        [finalPresentedSectionsByTableView addObject:sectionIndexes];
    }
    [super setSectionCellsByTableView:finalSectionCellsByTableView];
    [self setPresentedSectionsByTableView:finalPresentedSectionsByTableView];
}

-(void)refreshTableViewSizes
{
    if([self hasMoreThanOneTableView])
    {
        self.firstColumnHeightConstraint.constant= ((UITableView*)self.tableViews[0]).contentSize.height;
        self.secondColumnHeightConstraint.constant =((UITableView*) self.tableViews[1]).contentSize.height;
        [self.tableViews[0] layoutIfNeeded];
        [self.tableViews[1] layoutIfNeeded];
    }
}

/* TODO: move this to the "select profile screen"
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
*/
#pragma mark - Suggestion Table



-(void)suggestionTableDidStartEditing:(TextFieldSuggestionTable *)table
{
    [table removeFromSuperview];
    if(!IPAD)
    {
        UIImageView* background = [[UIImageView alloc] initWithImage:[self.view renderBlurWithTintColor:nil]];
        background.contentMode = UIViewContentModeBottom;
        table.backgroundView = background;
        
        UIView *colorOverlay = [[UIView alloc] initWithFrame:background.bounds];
        colorOverlay.bgStyle = @"darkBlue.alpha4";
        colorOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [background addSubview:colorOverlay];
    }
    
    CGRect newFrame = table.frame;
    newFrame.origin = [self.view convertPoint:table.textField.superview.frame.origin fromView:table.textField.superview.superview];
    newFrame.origin.y += table.textField.superview.frame.size.height;
    newFrame.size.height = self.view.frame.size.height - newFrame.origin.y;
    newFrame.size.width = table.textField.superview.frame.size.width;
    table.frame = newFrame;
    [self.view addSubview:table];
    
}

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    [self.nameCell.entryField resignFirstResponder];
    NameLookupWrapper* wrapper = (NameLookupWrapper*)object;
    if(wrapper.recordId)
    {
        PhoneBookProfile* profile = [[PhoneBookProfile alloc] initWithRecordId:wrapper.recordId];
        [profile loadData];
        [self loadDataFromProfile:profile];
    }
    else if (wrapper.managedObjectId)
    {
        [self didSelectRecipient:(Recipient*)[self.objectModel.managedObjectContext objectWithID:wrapper.managedObjectId]];
    }
    
}

#pragma mark - Keyboard show/hide




-(void)keyboardWillShow:(NSNotification*)note
{
    if(IPAD)
    {
        CGRect newframe = [self.view convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        CGFloat overlap = self.containerScrollView.frame.origin.y + self.containerScrollView.frame.size.height - newframe.origin.y;
        
        if(overlap >0)
        {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            if(UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, UIEdgeInsetsZero))
            {
                self.cachedInsets = self.containerScrollView.contentInset;
            }
            
            UIEdgeInsets newInsets = self.cachedInsets;
            newInsets.bottom += overlap;
            self.containerScrollView.contentInset = newInsets;
            
            UIView *firstResponder = [UIResponder currentFirstResponder];
            if(firstResponder)
            {
                [self scrollScrollViewToShowView:firstResponder];
            }
            
            [self suggestionTableDidStartEditing:self.suggestionTable];
            
            [UIView commitAnimations];
            

        }
        
        self.suggestionTable.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
    }
    else
    {
        [super keyboardWillShow:note];
    }
}

-(void)keyboardWillHide:(NSNotification*)note
{
    if(IPAD)
    {
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.containerScrollView.contentInset = self.cachedInsets;
        
        [UIView commitAnimations];
        
        self.cachedInsets = UIEdgeInsetsZero;
        self.suggestionTable.contentInset = UIEdgeInsetsZero;
    }
    else
    {
        [super keyboardWillHide:note];
    }
}

-(void)textFieldEntryFinished
{
    if(IPAD)
    {
        self.containerScrollView.scrollEnabled = YES;
    }
    else
    {
        ((UITableView*)self.tableViews[0]).scrollEnabled = YES;
    }
}

-(void)scrollToCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView
{
    if(IPAD)
    {
        [self scrollScrollViewToShowView:cell];
    }
    else
    {
         [super scrollToCell:cell inTableView:tableView];
        tableView.scrollEnabled = NO;
    }
}

-(void)scrollScrollViewToShowView:(UIView*)targetView
{
    
        if(targetView == self.nameCell || targetView == self.nameCell.entryField)
        {
            self.containerScrollView.scrollEnabled = NO;
        }
    CGRect showRect = CGRectMake(0, self.containerScrollView.contentSize.height - 1, 1, 1);
        [self.containerScrollView scrollRectToVisible:showRect animated:NO];

}

@end
