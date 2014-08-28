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
#import "CountrySelectionCell.h"
#import "Country.h"
#import "ObjectModel+Countries.h"
#import "CurrenciesOperation.h"
#import "CountriesOperation.h"
#import "CountrySuggestionCellProvider.h"
#import "StateSuggestionProvider.h"

static NSUInteger const kRecipientSection = 0;
static NSUInteger const kCurrencySection = 1;
static NSUInteger const kRecipientFieldsSection = 2;
static NSUInteger const kAddressSection = 3;


NSString *const kButtonCellIdentifier = @"kButtonCellIdentifier";

@interface RecipientViewController () <ABPeoplePickerNavigationControllerDelegate, SuggestionTableDelegate, CountrySelectionCellDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;

@property (nonatomic, strong) NSArray *recipientCells;
@property (nonatomic, strong) RecipientEntrySelectionCell *nameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;

@property (nonatomic, strong) NSArray *currencyCells;
@property (nonatomic, strong) CurrencySelectionCell *currencyCell;

@property (nonatomic, strong) NSArray *recipientTypeFieldCells;


@property (nonatomic, strong) IBOutlet GreenButton *addButton;


@property (nonatomic, strong) NSMutableArray *addressCells;

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

@property (nonatomic, strong) TransferwiseOperation *retrieveCurrenciesOperation;

//Address cells

@property (nonatomic,strong)TextEntryCell *addressCell;
@property (nonatomic,strong)TextEntryCell *postCodeCell;
@property (nonatomic,strong)TextEntryCell *cityCell;
@property (nonatomic,strong)CountrySelectionCell *countryCell;
@property (nonatomic,strong)TextEntryCell *stateCell;

@property (nonatomic, strong) CountrySuggestionCellProvider *countryCellProvider;
@property (nonatomic, strong) StateSuggestionProvider *stateCellProvider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopContentOffset;


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
    
    
     NSMutableArray *addressCells = [NSMutableArray array];
    
    CountrySelectionCell *countryCell = [CountrySelectionCell loadInstance];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"personal.profile.country.label", nil) value:@""];
    [countryCell setCellTag:@"countryCode"];
    NSFetchedResultsController* countriesFetcher = [self.objectModel fetchedControllerForAllCountries];
    
    self.countryCellProvider = [[CountrySuggestionCellProvider alloc] init];
    
    [self.countryCellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForAllCountries]];
    
    [super configureWithDataSource:self.countryCellProvider
						 entryCell:self.countryCell
							height:self.countryCell.frame.size.height];
	
	[self.countryCell setSelectionHandler:^(NSString *countryName) {
        [weakSelf didSelectCountry:countryName];
    }];
    
	self.countryCell.countrySelectionDelegate = self;
    
    TRWProgressHUD * hud = nil;
    if([countriesFetcher.fetchedObjects count]<=0)
    {
        hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    }
    CountriesOperation *operation = [CountriesOperation operation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCompletionHandler:^(NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.countries.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"personal.profile.countries.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
            return;
        }
        
    }];
    [operation execute];
    
    TextEntryCell *stateCell = [TextEntryCell loadInstance];
    [self setStateCell:stateCell];
    [stateCell configureWithTitle:NSLocalizedString(@"personal.profile.state.label", nil) value:@""];
    [stateCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [stateCell setCellTag:@"state"];
    
    self.stateCellProvider = [[StateSuggestionProvider alloc] init];
    [super configureWithDataSource:self.stateCellProvider
                         entryCell:self.stateCell
                            height:self.stateCell.frame.size.height];
    

    
    TextEntryCell *addressCell = [TextEntryCell loadInstance];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"personal.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [addressCell setCellTag:@"addressFirstLine"];
    
    TextEntryCell *postCodeCell = [TextEntryCell loadInstance];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"personal.profile.post.code.label", nil) value:@""];
    [postCodeCell setCellTag:@"postCode"];
    
    TextEntryCell *cityCell = [TextEntryCell loadInstance];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"personal.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [cityCell setCellTag:@"city"];
    
    self.addressCells = addressCells;
    
    
}


-(void)setupTableView:(UITableView*)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"RecipientEntrySelectionCell" bundle:nil] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"CountrySelectCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];
    
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


    if (self.preLoadRecipientsWithCurrency && [Credentials userLoggedIn]) {
        [self.cellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForRecipientsWithCurrency:self.preLoadRecipientsWithCurrency]];
    }

    [self.currencyCell setAllCurrencies:[self.objectModel fetchedControllerForAllCurrencies]];
    
    if (self.preLoadRecipientsWithCurrency) {
        [self handleCurrencySelection:self.preLoadRecipientsWithCurrency];
    }
    
    if(self.noPendingPayment)
    {
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"recipient.controller.refreshing.message", nil)];
        
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
        [self setRetrieveCurrenciesOperation:currenciesOperation];
        [currenciesOperation setObjectModel:self.objectModel];
        [currenciesOperation setResultHandler:^(NSError *error) {
            if (error) {
                [hud hide];
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipient.types.load.error.title", nil) error:error];
                [alertView show];
                return;
            }
            
            if (recipientsOperation) {
                [self setRetrieveCurrenciesOperation:recipientsOperation];
                [recipientsOperation execute];
            } else {
                dataLoadCompletionBlock();
            }
        }];
        
        [currenciesOperation execute];
    }
   
    [self didSelectRecipient:self.recipient];

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
    RecipientType* type = recipient ? recipient.type : self.currency.defaultRecipientType;

    
    
    NSArray* allowedTypes = [self allTypes];
    RecipientType *allowedType = type;
    if(![allowedTypes containsObject:type])
    {
        allowedType = [allowedTypes firstObject];
    }
    
    if(type != allowedType || (type.recipientAddressRequired && ![recipient hasAddress]))
    {
        self.recipient = nil;
        if(recipient)
        {
            self.templateRecipient = recipient;
        }
    }
    else
    {
        [self setRecipient:recipient];
    }
    type = allowedType;
    
    [self handleSelectionChangeToType:type allTypes:allowedTypes];
    
    if (!self.recipient) {
        //We're creating a new recipient
        if(self.templateRecipient)
        {
            [self.nameCell setValue:self.templateRecipient.name];
            [self.emailCell setValue:self.templateRecipient.email];
            
            
            for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {

                
                RecipientTypeField *field = fieldCell.type;
                [fieldCell setValue:[self.templateRecipient valueField:field]];
                if([fieldCell.value length]>0)
                {
                    [fieldCell setEditable:NO];
                }
            }
            
            [self setAddressFieldsFromRecipient:self.templateRecipient];

        }
        else
        {
            [self.nameCell setValue:@""];
            [self.emailCell setValue:@""];
            [self.nameCell setEditable:YES];
            for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {
                [fieldCell setValue:@""];
                [fieldCell setEditable:YES];
            }
            [self setAddressFieldsFromRecipient:nil];
        }
        
        [self setAddressFieldsEditable:YES];
        
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        //We're using an existing recipient.
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"ExistingRecipientSelected"];
        [self.nameCell setValue:recipient.name];
        [self.emailCell setValue:recipient.email];

        [self updateUserNameText];
        
        for (RecipientFieldCell *fieldCell in self.recipientTypeFieldCells) {

            RecipientTypeField *field = fieldCell.type;
            [fieldCell setValue:[recipient valueField:field]];
            [fieldCell setEditable:NO];
        }
        [self setAddressFieldsFromRecipient:recipient];
        [self setAddressFieldsEditable:NO];
    });
}

-(void)setAddressFieldsFromRecipient:(Recipient*)recipient
{

    self.addressCell.value = recipient.addressFirstLine;
    self.postCodeCell.value = recipient.addressPostCode;
    self.cityCell.value = recipient.addressCity;
    self.countryCell.value = recipient.addressCountryCode;
    self.stateCell.value = recipient.addressState;
    
    [self includeStateCell:([@"usa" caseInsensitiveCompare:recipient.addressCountryCode]==NSOrderedSame)];
    
}

-(void)setAddressFieldsEditable:(BOOL)editable
{
    for(TextEntryCell* cell in self.addressCells)
    {
        [cell setEditable:editable];
    }
}

- (void)handleCurrencySelection:(Currency *)currency {
    void(^selectBlock)(void) = ^{
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"CurrencyRecipientSelected" withLabel:currency.code];
        
        MCLog(@"Did select currency:%@. Default type:%@", currency.code, currency.defaultRecipientType.type);
        
        RecipientType *type = currency.defaultRecipientType;
        MCLog(@"Have %d fields", [type.fields count]);
        
        [self setCurrency:currency];
        [self setRecipientType:type];
        
        NSArray *allTypes = [self allTypes];
        if(![allTypes containsObject:type])
        {
            type = [allTypes firstObject];
        }
        
        [self handleSelectionChangeToType:type allTypes:allTypes];
    };
    if(![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), selectBlock);
    }
    else
    {
        selectBlock();
    }
        
}

- (void)handleSelectionChangeToType:(RecipientType *)type allTypes:(NSArray *)allTypes {
    MCLog(@"handleSelectionChangeToType:%@", type.type);
    NSArray *cells = [self buildCellsForType:type allTypes:allTypes];
    [self setRecipientType:type];
    [self setRecipientTypeFieldCells:cells];
    if([self hasMoreThanOneTableView])
    {
        if(type.recipientAddressRequiredValue)
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells,self.addressCells,self.currencyCells], @[cells]]];
        }
        else
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells,self.currencyCells], @[cells]]];
        }
        
        [self.tableViews makeObjectsPerformSelector:@selector(reloadData)];
        [self refreshTableViewSizes];
        [self configureForInterfaceOrientation:self.interfaceOrientation];
    }
    else
    {
        if(type.recipientAddressRequiredValue)
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells, self.addressCells, self.currencyCells, cells]]];
        }
        else
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells, self.currencyCells, cells]]];
        }
        
        [self.tableViews[0] reloadData];
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

    PendingPayment *payment = [self pendingPayment];

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
    recipientInput.addressFirstLine = [self.addressCell value];
    recipientInput.addressPostCode = [self.postCodeCell value];
    recipientInput.addressCity = [self.cityCell value];
    recipientInput.addressCountryCode = [self.countryCell value];
    if ([@"usa" caseInsensitiveCompare:self.countryCell.value]== NSOrderedSame)
    {
        NSString* stateCode = [StateSuggestionProvider stateCodeFromTitle:self.stateCell.value];
        if(stateCode)
        {
            recipientInput.addressState = stateCode;
        }
    }

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
    
    if(self.recipientType.recipientAddressRequiredValue)
    {
        BOOL addressValidationFailed = NO;
        for(TextEntryCell* cell in self.addressCells)
        {
            if (![[cell value] hasValue])
            {
                addressValidationFailed = YES;
                break;
            }
        }
        if(addressValidationFailed)
        {
            [issues appendIssue:[NSString stringWithFormat:NSLocalizedString(@"recipient.controller.validation.error.address", nil),self.currency.code]];
        }
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
    else if ([self.presentedSectionsByTableView[index][section] integerValue] == kAddressSection)
    {
        return 0;
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
    else if ([self.presentedSectionsByTableView[index][section] integerValue] == kAddressSection)
    {
        return nil;
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
        case kAddressSection:
            return NSLocalizedString(@"recipient.controller.section.title.address", nil);
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
        if(self.recipientType.recipientAddressRequired)
        {
            [sectionIndexes addObject:@(kAddressSection)];
        }
            
        
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
        
        if (self.recipientType.recipientAddressRequired)
        {
            [sectionIndexes addObject:@(kAddressSection)];
        }
        
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


#pragma mark - Text entry finisehd

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

#pragma mark - recipient type helpers

-(NSArray*)allTypes
{
    if ([self pendingPayment])
    {
        return [self.objectModel.pendingPayment.allowedRecipientTypes array];
    }
    else
    {
        return [self.currency.recipientTypes array];
    }
}

-(void)countrySelectionCell:(CountrySelectionCell *)cell selectedCountry:(Country *)country
{
    [self includeStateCell:([@"usa" caseInsensitiveCompare:country.iso3Code]==NSOrderedSame)];
}

-(void)includeStateCell:(BOOL)includeState
{
    BOOL didIncludeState = NO;
    BOOL didRemoveState = NO;
    if(includeState)
    {
        if ([self.addressCells indexOfObject:self.stateCell]==NSNotFound)
        {
            [self.addressCells insertObject:self.stateCell atIndex:1];
            didIncludeState = YES;
        }
    }
    else
    {
        if ([self.addressCells indexOfObject:self.stateCell]!=NSNotFound)
        {
            [self.addressCells removeObject:self.stateCell];
            didRemoveState = YES;
        }
    }
 
    if(self.recipientType.recipientAddressRequired)
    {
        if(IPAD)
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells,self.addressCells, self.currencyCells],@[self.recipientTypeFieldCells]]];
            if(didIncludeState)
            {
                [self.tableViews[0] reloadData];
                [self refreshTableViewSizes];
                [self configureForInterfaceOrientation:self.interfaceOrientation];
            }
            else if(didRemoveState)
            {
                [self.tableViews[0] reloadData];
                [self refreshTableViewSizes];
                [self configureForInterfaceOrientation:self.interfaceOrientation];
            }
        }
        else
        {
            [self setSectionCellsByTableView:@[@[self.recipientCells,self.addressCells, self.currencyCells,self.recipientTypeFieldCells]]];
            if(didIncludeState)
            {
                [self.tableViews[0] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            else if(didRemoveState)
            {
                [self.tableViews[0] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }

}

-(PendingPayment*)pendingPayment
{
    if(!self.noPendingPayment)
    {
        return [self.objectModel pendingPayment];
    }
    return nil;
}

#pragma mark - suggestions tables

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    if(table.associatedView == self.nameCell)
    {
        //Name suggestion
        EmailLookupWrapper* wrapper = (EmailLookupWrapper*)object;
        if(wrapper.recordId)
        {
            [self loadDataFromWrapper:wrapper];
        }
        else if (wrapper.managedObjectId)
        {
            [self didSelectRecipient:(Recipient*)[self.objectModel.managedObjectContext objectWithID:wrapper.managedObjectId]];
        }
        [self moveFocusOnNextEntryAfterCell:self.nameCell];
    }
    else if(table.associatedView == self.countryCell)
    {
        //Country suggestion
        [self didSelectCountry:(NSString *)object];
    }
    else
    {
        //state suggestion
        self.stateCell.value = (NSString*)object;
        [self moveFocusOnNextEntryAfterCell:self.stateCell];
    }
}

- (void)didSelectCountry:(NSString *)country
{
    self.countryCell.value = country;
    BOOL shouldIncludeStateCell = [@"usa" caseInsensitiveCompare:[self.countryCell.value lowercaseString]] == NSOrderedSame;
    [self includeStateCell: shouldIncludeStateCell];
    if(shouldIncludeStateCell)
    {
        [self.stateCell.entryField becomeFirstResponder];
    }
    else
    {
        [self.addressCell.entryField becomeFirstResponder];
    }
    
}

#pragma mark - CountrySelectionCell Delegate
- (Country *)getCountryByCode:(NSString *)code
{
	return [self.countryCellProvider getCountryByCode:code];
}

#pragma mark - Configure for interface orientation
-(void)configureForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //Lots of magic numbers here to match designs. Not sure what to do...
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        self.scrollViewTopContentOffset.constant = 120.0f;
        self.firstColumnLeftMargin.constant = 176.f;
        self.secondColumnLeftEdgeConstraint.constant = -409.f;
        self.secondColumnTopConstraint.constant = self.firstColumnHeightConstraint.constant + 50.f;
        
    }
    else
    {
        self.scrollViewTopContentOffset.constant = self.recipientType.recipientAddressRequired?30.0f:120.0f;
        self.firstColumnLeftMargin.constant = 60.f;
        self.secondColumnLeftEdgeConstraint.constant = 79.f;
        self.secondColumnTopConstraint.constant = 0.f;
    }

}

@end
