//
//  ProfileEditViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "ProfileSource.h"
#import "ButtonCell.h"
#import "UIColor+Theme.h"
#import "CountrySelectionCell.h"
#import "TRWAlertView.h"
#import "TransferwiseClient.h"
#import "PhoneBookProfileSelector.h"
#import "TRWProgressHUD.h"
#import "PhoneBookProfile.h"
#import "ObjectModel.h"
#import "UIApplication+Keyboard.h"
#import "ObjectModel+Countries.h"
#import "QuickProfileValidationOperation.h"
#import "PersonalProfileSource.h"
#import "TransferBackButtonItem.h"
#import "GoogleAnalytics.h"
#import "CountrySuggestionCellProvider.h"
#import "Country.h"
#import "Credentials.h"
#import "EmailEntryCell.h"

static NSUInteger const kButtonSection = 0;

@interface ProfileEditViewController ()<CountrySelectionCellDelegate, EmailEntryCellDelegate>

@property (nonatomic, strong) ProfileSource *profileSource;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) EmailEntryCell *emailCell;
@property (nonatomic, strong) NSArray *presentationCells;
@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) QuickProfileValidationOperation *quickProfileValidation;
@property (nonatomic, assign) BOOL inputCheckRunning;
@property (nonatomic, strong) CountrySuggestionCellProvider* cellProvider;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) BOOL isExistingEmail;

@end

@implementation ProfileEditViewController

- (id)initWithSource:(ProfileSource *)source quickValidation:(QuickProfileValidationOperation *)quickValidation
{
    self = [super initWithNibName:@"ProfileEditViewController" bundle:nil];
    if (self)
	{
        _profileSource = source;
        _quickProfileValidation = quickValidation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.profileSource setTableViews:self.tableViews];

    [self createPresentationCells];
}

- (void)createPresentationCells
{
    NSArray *presented = [self.profileSource presentedCells:![Credentials userLoggedIn]
						  && self.allowProfileSwitch];

    CountrySelectionCell *countryCell = nil;
	EmailEntryCell *emailCell = nil;
	for (NSArray* table in presented)
	{
		for (NSArray *cells in table) {
			for (UITableViewCell *cell in cells) {
				if ([cell isKindOfClass:[CountrySelectionCell class]])
				{
					countryCell = (CountrySelectionCell *)cell;
					break;
				}
				else if([cell isKindOfClass:[EmailEntryCell class]])
				{
					emailCell = (EmailEntryCell *)cell;
				}
				
				if(countryCell && emailCell)
				{
					break;
				}
			}
			
			if(countryCell && emailCell)
			{
				break;
			}
		}
	}
	
    [self setCountryCell:countryCell];
	[self setEmailCell:emailCell];
	
	self.cellProvider = [[CountrySuggestionCellProvider alloc] init];
    
    [super configureWithDataSource:self.cellProvider
						 entryCell:countryCell
							height:countryCell.frame.size.height];
	
	__weak typeof(self) weakSelf = self;
	[countryCell setSelectionHandler:^(NSString *countryName) {
        [weakSelf didSelectCountry:countryName];
    }];
	
	countryCell.delegate = self;
	emailCell.delegate = self;

    [self setPresentationCells:presented];
}

- (void)setObjectModel:(ObjectModel *)objectModel
{
    _objectModel = objectModel;
    [self.profileSource setObjectModel:objectModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.shown)
	{
        return;
    }

    [self pullDetails];
    [self setShown:YES];

    if ([self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
        [[GoogleAnalytics sharedInstance] sendScreen:@"Enter sender details"];
    }
}

#pragma mark - Suggestion Table

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    [super suggestionTable:table selectedObject:object];
    [self didSelectCountry:(NSString *)object];
}

- (void)didSelectCountry:(NSString *)country
{
    self.countryCell.value = country;
}

- (void)pullCountriesWithHud:(TRWProgressHUD *)hud completionHandler:(TRWActionBlock)completion
{
    CountriesOperation *operation = [CountriesOperation operation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCompletionHandler:^(NSError *error) {
        if (error)
		{
            [hud hide];

            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.countries.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"personal.profile.countries.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
            return;
        }

        completion();
    }];
    [operation execute];
}

- (void)pullDetails
{
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.message", nil)];

    [self pullCountriesWithHud:hud completionHandler:^{
		[self.cellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForAllCountries]];
		
        [self.profileSource pullDetailsWithHandler:^(NSError *profileError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];

                if (profileError) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.refresh.error.title", nil)
                                                                       message:NSLocalizedString(@"personal.profile.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }

                self.sectionCellsByTableView = self.presentationCells;
                [self reloadTableViews];
            });
        }];

    }];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != kButtonSection)
	{
        return;
    }

    PhoneBookProfileSelector *selector = [[PhoneBookProfileSelector alloc] init];
    [self setProfileSelector:selector];
    [selector presentOnController:self completionHandler:^(PhoneBookProfile *profile) {
        [self.profileSource loadDataFromProfile:profile];
    }];
}

- (void)validateProfile
{
	[UIApplication dismissKeyboard];
	
    if (![self.profileSource inputValid])
	{
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
                                                           message:NSLocalizedString(@"personal.profile.validation.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
	
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.verify.message", nil)];
    
    NSManagedObjectID *profile = [self.profileSource enteredProfile];
	
    [self.profileSource validateProfile:profile withValidation:self.profileValidation completion:^(NSError *error) {
        [hud hide];
		
        if (error)
		{
			TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"personal.profile.verify.error.title", nil) error:error];
			[alertView show];
        }
    }];
}

- (void)textFieldEntryFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"textFieldEntryFinished");
        if (self.inputCheckRunning) {
            MCLog(@"Validation in progress");
            return;
        }

        [self setInputCheckRunning:YES];
        [self.profileSource fillQuickValidation:self.quickProfileValidation];

        __block __weak ProfileEditViewController *weakSelf = self;
        [self.quickProfileValidation setValidationHandler:^(NSArray *issues) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.profileSource markCellsWithIssues:issues];
                [weakSelf setInputCheckRunning:NO];
            });
        }];

        [self.quickProfileValidation execute];
    });
}

#pragma mark - CountrySelectionCell Delegate
- (Country *)getCountryByCode:(NSString *)code
{
	return [self.cellProvider getCountryByCode:code];
}

#pragma mark - Show as Login
- (void)showAsLogin
{
	//remove cells
	//rebind tables
	//rename button
	//switch out button action
	//implement login
	//return with filled profile
}

@end
