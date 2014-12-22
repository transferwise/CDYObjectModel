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
#import "SelectionCell.h"
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
#import "AuthenticationHelper.h"
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
#import "StateSuggestionCellProvider.h"
#import "ValidatorFactory.h"
#import "EmailValidation.h"

@interface ProfileEditViewController ()<SelectionCellDelegate, TextEntryCellDelegate>

@property (nonatomic, strong) ProfileSource *profileSource;
@property (nonatomic, strong) SelectionCell *countryCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) SelectionCell *stateCell;
@property (nonatomic, strong) DoublePasswordEntryCell *passwordCell;
@property (nonatomic, strong) SwitchCell *sendAsBusinessCell;
@property (nonatomic, strong) NSArray *presentationCells;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, assign) BOOL shown;
@property (nonatomic, strong) QuickProfileValidationOperation *quickProfileValidation;
@property (nonatomic, assign) BOOL inputCheckRunning;
@property (nonatomic, strong) CountrySuggestionCellProvider* countryCellProvider;
@property (nonatomic, strong) StateSuggestionCellProvider* stateCellProvider;
@property (nonatomic) CGFloat bottomInset;
@property (nonatomic) BOOL isExistingEmail;
@property (nonatomic, strong) IBOutlet UIView* footerView;
@property (nonatomic) BOOL showingLogin;
@property (nonatomic, strong) AuthenticationHelper* loginHelper;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) NSString* actionButtonTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ipadFooterHeight;
@property (nonatomic) BOOL removeFromNavStackOnDidDisappear;

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
		_loginHelper = [[AuthenticationHelper alloc] init];
		
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

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UINavigationController * navController = self.navigationController;
    if(self.removeFromNavStackOnDidDisappear && [navController.viewControllers containsObject:self.parentViewController])
    {
        NSMutableArray *modifiedNavStack = [navController.viewControllers mutableCopy];
        [modifiedNavStack removeObject:self.parentViewController];
        navController.viewControllers = modifiedNavStack;
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
    
	self.countryCell.selectionDelegate = self;
	
	self.stateCell = self.profileSource.stateCell;
    self.stateCellProvider = [[StateSuggestionCellProvider alloc] init];
    [super configureWithDataSource:self.stateCellProvider
						 entryCell:self.stateCell
							height:self.stateCell.frame.size.height];
	
	[self.stateCell setSelectionHandler:^(NSString *state) {
        [weakSelf didSelectState:state];
    }];
	
	self.stateCell.selectionDelegate = self;

    [self setPresentationCells:presented];
}

- (void)setCells:(NSArray *)presented
{
	SelectionCell *countryCell = nil;
	TextEntryCell *emailCell = nil;
	DoublePasswordEntryCell *passwordCell = nil;
	SwitchCell *sendAsBusinessCell = nil;
	
	for (NSArray* table in presented)
	{
		for (NSArray *sections in table)
		{
			for (UITableViewCell *cell in sections)
			{
				if ([cell isKindOfClass:[SelectionCell class]])
				{
					countryCell = (SelectionCell *)cell;
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
		if (self.isShownInPaymentFlow)
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
		[self validateProfile];
	}
}

- (BOOL)createSendAsBusinessCell
{
	return self.allowProfileSwitch;
}

- (void)textEntryFinishedInCell:(UITableViewCell *)cell
{
	if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[PersonalPaymentProfileViewController class]]
		&& cell == self.emailCell
		&& [self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
		TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
		[hud setMessage:NSLocalizedString(@"personal.profile.email.validating", nil)];
		
		ValidatorFactory *validatorFactory = [[ValidatorFactory alloc] initWithObjectModel:self.objectModel];
		id<EmailValidation> validator = [validatorFactory getValidatorWithType:ValidateEmail];
		
		[validator verifyEmail:[self.emailCell value] withResultBlock:^(BOOL available, NSError *error)
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
		[self didSelectState:(NSString *)object];
    }
    self.suppressAnimation = NO;
}

- (void)didSelectCountry:(NSString *)country
{
    self.countryCell.value = country;
	TextEntryCell *stateCell = [self.profileSource countrySelectionCell:self.countryCell
													   didSelectCountry:[self.countryCellProvider getCountryByCodeOrName:self.countryCell.value]
														 withCompletion:^{
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [UIView animateWithDuration:0.2f animations:^{
                                                                     [self refreshTableViewSizes];
                                                                 } completion:^(BOOL finished) {
                                                                     [self forceLayoutOfSuggestionTable];
                                                                 }];
                                                             });
                                                             
														 }];
	
	if (stateCell)
	{
		[stateCell.entryField setDelegate:self];
	}
	else
	{
		self.stateCell.value = @"";
		[self didSelectState:@""];
	}
	
	[self moveFocusOnNextEntryAfterCell:self.countryCell];
}

- (void)didSelectState:(NSString *)state
{
	self.stateCell.value = state;
	
	if ([self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
		TextEntryCell* occupationCell =[(PersonalProfileSource *)self.profileSource stateSelectionCell:self.stateCell
																								 state:[self.stateCellProvider getByCodeOrName:self.stateCell.value]
																						withCompletion:^{
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [UIView animateWithDuration:0.2f animations:^{
                                                                                                    [self refreshTableViewSizes];
                                                                                                }];

                                                                                            });
                                                                                            
																							
																						}];
		if (occupationCell)
		{
			[occupationCell.entryField setDelegate:self];
		}
	}
}

- (void)pullCountriesWithHud:(TRWProgressHUD *)hud completionHandler:(TRWActionBlock)completion
{
    if(self.executedOperation)
    {
        [hud hide];
    }
    else
    {
        CountriesOperation *operation = [CountriesOperation operation];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        __weak typeof(self) weakSelf = self;
        [operation setCompletionHandler:^(NSError *error) {
            if (error)
            {
                [hud hide];
                 weakSelf.executedOperation = nil;
            }
            else if(completion)
            {
                completion();
            }
        }];
        [operation execute];
    }
}

- (void)pullDetails
{
    if(self.executedOperation)
    {
        return;
    }
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.message", nil)];
    __weak typeof(self) weakSelf = self;
    [self pullCountriesWithHud:hud completionHandler:^{
		[self.countryCellProvider setAutoCompleteResults:[self.objectModel fetchedControllerForAllCountries]];
        [self.profileSource pullDetailsWithHandler:^(NSError *profileError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                weakSelf.executedOperation = nil;
                if (profileError)
				{
                    return;
                }
                weakSelf.sectionCellsByTableView = self.presentationCells;
                [weakSelf reloadTableViews];
				[weakSelf refreshTableViewSizes];
				[weakSelf configureForInterfaceOrientation:self.interfaceOrientation];
            });
        }];

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
	
	if ([self.profileSource isKindOfClass:[PersonalProfileSource class]])
	{
		PersonalProfileSource* personalProfile = (PersonalProfileSource *)self.profileSource;
		
		if (![personalProfile isValidDateOfBirth])
		{
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
															   message:NSLocalizedString(@"personal.profile.validation.dateofbirth.invalid.message", nil)];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[alertView show];
			return;
		}
		
		if (![personalProfile isValidPhoneNumber])
		{
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
															   message:NSLocalizedString(@"personal.profile.validation.phone.invalid.message", nil)];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[alertView show];
			return;
		}
		
		if (!self.isExisting)
		{
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
	}
	
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.verify.message", nil)];
    
    NSManagedObjectID *profile = [self.profileSource enteredProfile];
	
    [self.profileSource validateProfile:profile
						 withValidation:self.profileValidation
							 completion:^(NSError *error) {
        [hud hide];
		
        if (error)
		{
			TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"personal.profile.verify.error.title", nil) error:error];
			[alertView show];
			return;
        }
		
		if (self.isExisting && !self.doNotShowSuccessMessageForExisting)
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

#pragma mark - SelectionCell Delegate
- (id<SelectionItem>)selectionCell:(SelectionCell*)cell getByCodeOrName:(NSString *)codeOrName
{
	if (cell == self.countryCell)
	{
		return [self.countryCellProvider getCountryByCodeOrName:codeOrName];
	}
	else
	{
		return [self.stateCellProvider getByCodeOrName:codeOrName];
	}
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
                                         keepPendingPayment:YES
								   navigationControllerView:self.navigationController.view
												objectModel:self.objectModel
											   successBlock:^{
                                                   [[GoogleAnalytics sharedInstance] sendAppEvent:@"UserLogged" withLabel:@"tw"];
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

    payment.user = user;
    payment.recipient.user = user;
	
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
        
        self.removeFromNavStackOnDidDisappear = YES;
    }];
}

#pragma mark - Helpers

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

- (void)clearData
{
	[self.profileSource clearData];
	[self reloadTableViews];
}
@end
