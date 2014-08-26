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
#import "EmailLookupWrapper.h"
#import "MOMStyle.h"
#import "UIView+RenderBlur.h"
#import "UIResponder+FirstResponder.h"
#import "GreenButton.h"

static NSUInteger const kRecipientSection = 0;
static NSUInteger const kCurrencySection = 1;
static NSUInteger const kRecipientFieldsSection = 2;


NSString *const kButtonCellIdentifier = @"kButtonCellIdentifier";

@interface RecipientViewController () <ABPeoplePickerNavigationControllerDelegate, SuggestionTableDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) RecipientEntrySelectionCell *nameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypeFieldCells;

@property (nonatomic, strong) IBOutlet GreenButton *addButton;

@property (nonatomic, strong) Currency *currency;
@property (nonatomic, strong) RecipientType *recipientType;

@property (nonatomic, strong) Recipient *recipient;

@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

@property (nonatomic, strong) DataEntryDefaultHeader *recipientFieldsHeader;

@property (nonatomic, strong) NSArray *presentedSectionsByTableView;
@property (nonatomic, assign) CGFloat minimumFooterHeight;
@property (nonatomic, assign) BOOL shown;


@property (nonatomic, strong) NameSuggestionCellProvider *cellProvider;
@property (nonatomic, strong) EmailLookupWrapper *lastSelectedWrapper;

@property (nonatomic, assign) CGFloat cellHeight;

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
    
     __weak typeof(self) weakSelf = self;
    
    RecipientEntrySelectionCell *nameCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [self setNameCell:nameCell];
    [nameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [nameCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.name", nil) value:@""];
    [nameCell setSelectionHandler:^(Recipient *recipient) {
        [weakSelf didSelectRecipient:recipient];
    }];
    

    TextEntryCell *emailCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    self.emailCell = emailCell;
    [emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailCell.entryField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailCell configureWithTitle:NSLocalizedString(@"recipient.controller.cell.label.email", nil) value:@""];
    

    [self setRecipientCells:@[nameCell,emailCell]];

    NSMutableArray *currencyCells = [NSMutableArray array];
    
    CurrencySelectionCell *currencyCell = [self.tableViews[0] dequeueReusableCellWithIdentifier:TWCurrencySelectionCellIdentifier];
    [self setCurrencyCell:currencyCell];
    currencyCell.hostForCurrencySelector = self;
    [currencyCell setSelectionHandler:^(Currency *currency) {
        [weakSelf handleCurrencySelection:currency];
    }];
    [currencyCells addObject:currencyCell];

    [self setCurrencyCells:currencyCells];

    [self.addButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];

    if (self.preLoadRecipientsWithCurrency) {
        [self.currencyCell setEditable:NO];
    }
    
    self.cellProvider = [[NameSuggestionCellProvider alloc] init];
    
    [super configureWithDataSource:self.cellProvider
						 entryCell:nameCell
							height:self.cellHeight];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{ 
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self configureForInterfaceOrientation:toInterfaceOrientation];
    self.suggestionTable.alpha = 0.0f;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self suggestionTableDidStartEditing:self.suggestionTable];
    self.suggestionTable.alpha = 1.0f;
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
    
    [self refreshTableViewSizes];
    [self configureForInterfaceOrientation:self.interfaceOrientation];

    if (self.shown) {
        return;
    }

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if(! self.navigationItem.leftBarButtonItem)
    {
        [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
    }
    else
    {
        //presented modally with added close button. set progress 0
        self.addButton.progress = 0.0f;
    }
    
    if([self hasMoreThanOneTableView])
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells,self.currencyCells], @[]]];
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
        [self.cellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForRecipientsWithCurrency:self.preLoadRecipientsWithCurrency]];
    }

    [self.currencyCell setAllCurrencies:[self.objectModel fetchedControllerForAllCurrencies]];

    if (self.preLoadRecipientsWithCurrency) {
        [self handleCurrencySelection:self.preLoadRecipientsWithCurrency];
    }

    __weak typeof(self) weakSelf = self;
    
    void (^dataLoadCompletionBlock)() = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [weakSelf didSelectRecipient:weakSelf.recipient];
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
            [weakSelf setExecutedOperation:recipientsOperation];
            [recipientsOperation execute];
        } else {
            dataLoadCompletionBlock();
        }
    }];

    [currenciesOperation execute];

    [self setShown:YES];
}


- (void)loadDataFromWrapper:(EmailLookupWrapper *)wrapper {
    [self didSelectRecipient:nil];
    self.lastSelectedWrapper = wrapper;
    self.nameCell.value = [wrapper presentableString:FirstNameFirst];
    self.emailCell.value = wrapper.email;
    
    [self updateUserNameText];
    
    PhoneBookProfile* profile = [[PhoneBookProfile alloc] initWithRecordId:wrapper.recordId];
    [profile loadData];
    
    __weak typeof(self) weakSelf = self;
    [profile loadThumbnail:^(PhoneBookProfile* profile, UIImage *image) {
        if (weakSelf.lastSelectedWrapper.recordId == profile.recordId )
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

        [self updateUserNameText];
        
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
        [self setSectionCellsByTableView:@[@[self.recipientCells,self.currencyCells], @[cells]]];
        [self.tableViews[1] reloadData];
    }
    else
    {
        [self setSectionCellsByTableView:@[@[self.recipientCells, self.currencyCells, cells]]];
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
    
    [self updateUserNameText];

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
        if ([cell isKindOfClass:[TransferTypeSelectionHeader class]]) {
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
            return nil;
        case kRecipientFieldsSection:
            return nil; //Set directly on headerview.
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
        
        NSMutableArray *cells = [sectionCellsByTableView[0] mutableCopy];
        NSMutableArray *sectionIndexes = [NSMutableArray array];
        
        [sectionIndexes addObject:@(kRecipientSection)];
        
        if (self.preLoadRecipientsWithCurrency) {
            [cells removeObject:self.currencyCells];
        } else {
            [sectionIndexes addObject:@(kCurrencySection)];
        }
        
        finalSectionCellsByTableView[0] = cells;
        [finalPresentedSectionsByTableView addObject:sectionIndexes];
        [finalPresentedSectionsByTableView addObject:@[@(kRecipientFieldsSection)]];
        
        ;
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

#pragma mark - Suggestion Table

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    [super suggestionTable:table selectedObject:object];
    EmailLookupWrapper* wrapper = (EmailLookupWrapper*)object;
    if(wrapper.recordId)
    {
        [self loadDataFromWrapper:wrapper];
    }
    else if (wrapper.managedObjectId)
    {
        [self didSelectRecipient:(Recipient*)[self.objectModel.managedObjectContext objectWithID:wrapper.managedObjectId]];
    }
    
}

#pragma mark - Keyboard show/hide


-(void)keyboardWillShow:(NSNotification*)note
{
    [super keyboardWillShow:note];
    CGRect newframe = [self.view convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    self.suggestionTable.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
}

-(void)keyboardWillHide:(NSNotification*)note
{
    
    [super keyboardWillHide:note];

    self.suggestionTable.contentInset = UIEdgeInsetsZero;
}

-(void)textFieldEntryFinished
{
    
    [self updateUserNameText];
}

#pragma mark - text dependent on user name

-(void)updateUserNameText
{
    NSString *recipientName = [self.nameCell.value length] > 0 ? self.nameCell.value: NSLocalizedString(@"recipient.controller.section.title.recipient.placeholder", nil);
    self.recipientFieldsHeader.titleLabel.text =  [NSString stringWithFormat:NSLocalizedString(@"recipient.controller.section.title.recipient.bank.details", nil),recipientName];
    self.currencyCell.titleLabel.text =  [NSString stringWithFormat:NSLocalizedString(@"recipient.controller.scell.title.recipient.currency", nil),recipientName];
}

@end
