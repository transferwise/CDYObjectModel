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
#import "UIColor+MOMStyle.h"
#import "PaymentFlow.h"
#import "DoublePasswordEntryCell.h"
#import "LoginHelper.h"
#import "User.h"
#import "PersonalProfile.h"
#import "ObjectModel+Users.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "ObjectModel+Recipients.h"
#import "Recipient.h"
#import "TypeFieldValue.h"
#import "SwitchCell.h"
#import "PersonalPaymentProfileViewController.h"
#import "StateSuggestionProvider.h"

@interface ProfileEditViewController ()<CountrySelectionCellDelegate, TextEntryCellDelegate>

@property (nonatomic, strong) ProfileSource *profileSource;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *stateCell;
@property (nonatomic, strong) DoublePasswordEntryCell *passwordCell;
@property (nonatomic, strong) SwitchCell *sendAsBusinessCell;
@property (nonatomic, strong) NSArray *presentationCells;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) QuickProfileValidationOperation *quickProfileValidation;
@property (nonatomic, assign) BOOL inputCheckRunning;
@property (nonatomic, strong) CountrySuggestionCellProvider* countryCellProvider;
@property (nonatomic, strong) StateSuggestionProvider* stateCellProvider;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) BOOL isExistingEmail;
@property (nonatomic, strong) IBOutlet UIView* footerView;
@property (nonatomic) BOOL showingLogin;
@property (nonatomic, strong) LoginHelper* loginHelper;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) NSString* actionButtonTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ipadFooterHeight;

@end

@implementation ProfileEditViewController

- (id)initWithSource:(ProfileSource *)source
	 quickValidation:(QuickProfileValidationOperation *)quickValidation
{
    self = [super initWithNibName:@"ProfileEditViewController" bundle:nil];
    if (self)
	{
        _profileSource = source;
        _quickProfileValidation = quickValidation;
		_loginHelper = [[LoginHelper alloc] init];
		
    }
    return self;
}

- (id)initWithSource:(ProfileSource *)source
	 quickValidation:(QuickProfileValidationOperation *)quickValidation
		 buttonTitle:(NSString *)buttonTitle
{
	self = [self initWithSource:source
				quickValidation:quickValidation];
	
	self.actionButtonTitle = buttonTitle;
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.profileSource setTableViews:self.tableViews];

    [self createPresentationCells];
    self.stateCell = self.profileSource.stateCell;
    self.stateCellProvider = [[StateSuggestionProvider alloc] init];
    [super configureWithDataSource:self.stateCellProvider
                             entryCell:self.stateCell
                                height:self.stateCell.frame.size.height];
    
	[self createFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pullDetails];
    
	if (self.shown)
	{
        return;
    }
	
    [self setShown:YES];
	
    if ([self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
        [[GoogleAnalytics sharedInstance] sendScreen:@"Enter sender details"];
    }
}

- (void)createPresentationCells
{
    NSArray *presented = [self.profileSource presentedCells:[self createSendAsBusinessCell]
												 isExisting:self.isExisting];

    [self setCells:presented];
	
	self.countryCellProvider = [[CountrySuggestionCellProvider alloc] init];
    
    [super configureWithDataSource:self.countryCellProvider
						 entryCell:self.countryCell
							height:self.countryCell.frame.size.height];
	
	__weak typeof(self) weakSelf = self;
	[self.countryCell setSelectionHandler:^(NSString *countryName) {
        [weakSelf didSelectCountry:countryName];
    }];
    
	self.countryCell.countrySelectionDelegate = self;

    [self setPresentationCells:presented];
}

- (void)setCells:(NSArray *)presented
{
	CountrySelectionCell *countryCell = nil;
	TextEntryCell *emailCell = nil;
	DoublePasswordEntryCell *passwordCell = nil;
	SwitchCell *sendAsBusinessCell = nil;
	
	for (NSArray* table in presented)
	{
		for (NSArray *sections in table)
		{
			for (UITableViewCell *cell in sections)
			{
				if ([cell isKindOfClass:[CountrySelectionCell class]])
				{
					countryCell = (CountrySelectionCell *)cell;
				}
				else if([cell isKindOfClass:[TextEntryCell class]]
						&& [((TextEntryCell *)cell).cellTag isEqualToString:@"EmailCell"])
				{
					emailCell = (TextEntryCell *)cell;
					emailCell.delegate = self;
				}
				else if([cell isKindOfClass:[DoublePasswordEntryCell class]])
				{
					passwordCell = (DoublePasswordEntryCell *)cell;
				}
				else if([cell isKindOfClass:[SwitchCell class]])
				{
					sendAsBusinessCell = (SwitchCell *)cell;
				}
				
				if(countryCell && emailCell
				   && passwordCell && sendAsBusinessCell)
				{
					break;
				}
			}
			
			if(countryCell && emailCell
			   && passwordCell && sendAsBusinessCell)
			{
				break;
			}
		}
	}
	
    [self setCountryCell:countryCell];
	[self setEmailCell:emailCell];
	[self setPasswordCell:passwordCell];
	[self setSendAsBusinessCell:sendAsBusinessCell];

}

- (void)setObjectModel:(ObjectModel *)objectModel
{
    _objectModel = objectModel;
    [self.profileSource setObjectModel:objectModel];
}

- (void)createFooterView
{
	if (self.actionButtonTitle)
	{
		[self.actionButton setTitle:self.actionButtonTitle forState:UIControlStateNormal];
	}
	
	if(!IPAD)
	{
		if (!self.isExisting)
		{
			self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
			if([self createSendAsBusinessCell])
			{
				[self.footerView setBackgroundColor:[UIColor colorFromStyle:@"lightBlueHighLighted"]];
			}
		}
	
		[self.footerView layoutSubviews];
		self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		//iPhone only has one table
		[self.tableViews[0] setTableFooterView:self.footerView];
	}
	else if(!self.showFooterViewForIpad)
	{
		self.ipadFooterHeight.constant = 0;
	}
}


- (IBAction)actionTapped:(id)sender
{
	if (self.showingLogin)
	{
		[self login];
	}
	else
	{
		[self validateProfile:self.isExisting];
	}
}

- (BOOL)createSendAsBusinessCell
{
	return self.allowProfileSwitch && ![Credentials userLoggedIn];
}

- (void)textEntryFinishedInCell:(UITableViewCell *)cell
{
	if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[PersonalPaymentProfileViewController class]]
		&& cell == self.emailCell
		&& [self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
		TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
		[hud setMessage:NSLocalizedString(@"personal.profile.email.validating", nil)];
		
		[self.profileValidation verifyEmail:[self.emailCell value] withResultBlock:^(BOOL available, NSError *error)
		 {
			 [hud hide];
			 
			 if (!available && !error)
			 {
				 [self showAsLogin];
			 }
			 else
			 {
				 [self showAsNormal];
			 }
			 
			 [self.passwordCell activate];
		 }];
	}
}

#pragma mark - Suggestion Table
-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    self.suppressAnimation = YES;
    [super suggestionTable:table selectedObject:object];
    if(table.associatedView == self.countryCell)
    {
        [self didSelectCountry:(NSString *)object];
    }
    else
    {
        self.stateCell.value = (NSString*)object;
    }
    self.suppressAnimation = NO;
}

- (void)didSelectCountry:(NSString *)country
{
    self.countryCell.value = country;
	TextEntryCell *stateCell = [self.profileSource countrySelectionCell:self.countryCell
													   didSelectCountry:[self getCountryByCode:self.countryCell.value]
														 withCompletion:^{
															 [self refreshTableViewSizes];
														 }];
	
	if (stateCell)
	{
		[stateCell.entryField setDelegate:self];
	}
	
	[self moveFocusOnNextEntryAfterCell:self.countryCell];
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
		[self.countryCellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForAllCountries]];
		
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
				[self refreshTableViewSizes];
				[self configureForInterfaceOrientation:self.interfaceOrientation];
            });
        }];

    }];
}

- (void)validateProfile
{
	[self validateProfile:NO];
}

- (void)validateProfile:(BOOL)isExisting
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
	
	if (!isExisting && [self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
		PersonalProfileSource* personalProfile = (PersonalProfileSource *)self.profileSource;
		
		if (![personalProfile arePasswordsMatching])
		{
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
															   message:NSLocalizedString(@"personal.profile.validation.password.error.notmatching.message", nil)];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[alertView show];
			return;
		}
		
		if (![personalProfile isPasswordLengthValid])
		{
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
															   message:NSLocalizedString(@"personal.profile.validation.password.error.invalid.length.message", nil)];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[alertView show];
			return;
		}
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
			return;
        }
		
		if (isExisting)
		{
			//show sucess message
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"profile.edit.save.success.header", nil)
															   message:NSLocalizedString(@"profile.edit.save.success.message", nil)];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
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
	return [self.countryCellProvider getCountryByCode:code];
}

#pragma mark - Show as Login
- (void)showAsLogin
{
	if (!self.showingLogin)
	{
		self.showingLogin = YES;
		
		if (IPAD)
		{
			[self maskNonLoginCells:[self.profileSource presentedLoginCells][0][0]];
		}
		else
		{
			self.sectionCellsByTableView = [self.profileSource presentedLoginCells];
		}
		
		[self reloadTableViews];
		if ([self.delegate respondsToSelector:@selector(changeActionButtonTitle:andAction:)])
		{
			__weak typeof(self) weakSelf = self;
			[self.delegate changeActionButtonTitle:NSLocalizedString(@"personal.profile.login.title", nil)
										 andAction:^{
											 [weakSelf login];
										 }];
		}
	}
}

- (void)showAsNormal
{
	if (self.showingLogin)
	{
		self.showingLogin = NO;
		
		if (IPAD)
		{
			self.sectionCellsByTableView = [self.profileSource presentedCells:[self createSendAsBusinessCell]
																   isExisting:self.isExisting];
			[self unmaskAllCells];
		}
		else
		{
			self.sectionCellsByTableView = [self.profileSource presentedCells:[self createSendAsBusinessCell]
																   isExisting:self.isExisting];
		}
		
		[self reloadTableViews];
		if ([self.delegate respondsToSelector:@selector(changeActionButtonTitle:andAction:)])
		{
			[self.delegate changeActionButtonTitle:NSLocalizedString(@"personal.profile.confirm.payment.button.title", nil)
										 andAction:nil];
		}
	}
}

- (void)login
{
	PendingPayment* pendingPayment = self.objectModel.pendingPayment;
	BOOL sendAsBusiness = self.sendAsBusinessCell.value;
	
	__weak typeof(self) weakSelf = self;
	[self.loginHelper validateInputAndPerformLoginWithEmail:self.emailCell.value
												   password:self.passwordCell.value
								   navigationControllerView:self.navigationController.view
												objectModel:self.objectModel
											   successBlock:^{
												   [weakSelf reloadDataAfterLoginWithPayment:pendingPayment
																			  sendAsBusiness:sendAsBusiness];
											   }
								  waitForDetailsCompletions:YES];
}

- (void)reloadDataAfterLoginWithPayment:(PendingPayment *)payment
						 sendAsBusiness:(BOOL)sendAsBusiness
{
	User *user = [self.objectModel currentUser];
    PersonalProfile *profile = [user personalProfileObject];
	
	profile.sendAsBusinessValue = sendAsBusiness;
	
	PendingPayment *pendingPayment = [self getPendingPaymentFromPayment:payment];
	[self setRecipient:payment.recipient forPayment:pendingPayment];
	
	[self.objectModel saveContext];
	
	TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.verify.message", nil)];
	
	[self.profileSource validateProfile:profile.objectID withValidation:self.profileValidation completion:^(NSError *error) {
        [hud hide];
		
        if (error)
		{
			TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"personal.profile.verify.error.title", nil) error:error];
			[alertView show];
			return;
        }
		
		[self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - Helpers
- (PendingPayment *)getPendingPaymentFromPayment:(PendingPayment *)payment
{
	PendingPayment *newPayment = [self.objectModel createPendingPayment];
	
	[newPayment setSourceCurrency:payment.sourceCurrency];
	[newPayment setTargetCurrency:payment.targetCurrency];
	[newPayment setPayIn:payment.payIn];
	[newPayment setPayOut:payment.payOut];
	[newPayment setConversionRate:payment.conversionRate];
	[newPayment setEstimatedDelivery:payment.estimatedDelivery];
	[newPayment setEstimatedDeliveryStringFromServer:payment.estimatedDeliveryStringFromServer];
	[newPayment setTransferwiseTransferFee:payment.transferwiseTransferFee];
	[newPayment setIsFixedAmountValue:payment.isFixedAmountValue];
    newPayment.allowedRecipientTypes = payment.allowedRecipientTypes;
	
	return newPayment;
}

- (void)setRecipient:(Recipient *)recipient forPayment:(PendingPayment *)payment
{
	Recipient *newRecipient = [self.objectModel createRecipient];
    newRecipient.name = recipient.name;
    newRecipient.currency = recipient.currency;
    newRecipient.type = recipient.type;
    newRecipient.email = recipient.email;
	
	for (TypeFieldValue *value in recipient.fieldValues)
	{
		[newRecipient setValue:value.value forField:value.valueForField];
	}
	
    [payment setRecipient:newRecipient];
}

- (void)maskNonLoginCells:(NSArray *)loginCells
{
	[self doForEachCell:^(UITableViewCell *cell) {
		if ([loginCells indexOfObject:cell] == NSNotFound
			&& [cell isKindOfClass:[TextEntryCell class]])
		{
			[(TextEntryCell *)cell setGrayedOut:YES];
		}
	}];
}

- (void)unmaskAllCells
{
	[self doForEachCell:^(UITableViewCell *cell) {
		if ([cell isKindOfClass:[TextEntryCell class]])
		{
			[(TextEntryCell *)cell setGrayedOut:NO];
		}
	}];
}

- (void)doForEachCell:(void (^)(UITableViewCell *))action
{
	for (NSArray* table in self.presentationCells)
	{
		for (NSArray *sections in table)
		{
			for (UITableViewCell *cell in sections)
			{
				action(cell);
			}
		}
	}
}
@end
