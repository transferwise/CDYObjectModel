//
//  PersonalProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "UIColor+Theme.h"
#import "TextEntryCell.h"
#import "ProfileDetails.h"
#import "TRWProgressHUD.h"
#import "TransferwiseClient.h"
#import "TRWAlertView.h"
#import "PersonalProfile.h"
#import "DateEntryCell.h"
#import "CountrySelectionCell.h"
#import "NSString+Validation.h"
#import "SavePersonalProfileOperation.h"
#import "UIApplication+Keyboard.h"
#import "ButtonCell.h"
#import "PhoneBookProfileSelector.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
#import "Credentials.h"

static NSUInteger const kButtonSection = 0;
static NSUInteger const kPersonalSection = 1;

@interface PersonalProfileViewController ()

@property (nonatomic, strong) ButtonCell *buttonCell;

@property (nonatomic, strong) NSArray *presentedCells;

@property (nonatomic, strong) TextEntryCell *firstNameCell;
@property (nonatomic, strong) TextEntryCell *lastNameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *phoneNumberCell;
@property (nonatomic, strong) DateEntryCell *dateOfBirthCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) TextEntryCell *postCodeCell;
@property (nonatomic, strong) TextEntryCell *cityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation PersonalProfileViewController

- (id)init {
    self = [super initWithNibName:@"PersonalProfileViewController" bundle:nil];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"DateEntryCell" bundle:nil] forCellReuseIdentifier:TWDateEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:TWButtonCellIdentifier];

    self.buttonCell = [self.tableView dequeueReusableCellWithIdentifier:TWButtonCellIdentifier];
    self.buttonCell.textLabel.text = NSLocalizedString(@"button.title.import.from.phonebook", nil);

    NSMutableArray *personalCells = [NSMutableArray array];

    TextEntryCell *firstNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setFirstNameCell:firstNameCell];
    [personalCells addObject:firstNameCell];
    [firstNameCell configureWithTitle:NSLocalizedString(@"personal.profile.first.name.label", nil) value:@""];
    [firstNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *lastNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setLastNameCell:lastNameCell];
    [personalCells addObject:lastNameCell];
    [lastNameCell configureWithTitle:NSLocalizedString(@"personal.profile.last.name.label", nil) value:@""];
    [lastNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:emailCell];
    [personalCells addObject:emailCell];
    [emailCell configureWithTitle:NSLocalizedString(@"personal.profile.email.label", nil) value:@""];
    [emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];

    //TODO jaanus: phone pad with custom accessory view
    TextEntryCell *phoneCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPhoneNumberCell:phoneCell];
    [personalCells addObject:phoneCell];
    [phoneCell configureWithTitle:NSLocalizedString(@"personal.profile.phone.label", nil) value:@""];

    DateEntryCell *dateOfBirthCell = [self.tableView dequeueReusableCellWithIdentifier:TWDateEntryCellIdentifier];
    [self setDateOfBirthCell:dateOfBirthCell];
    [personalCells addObject:dateOfBirthCell];
    [dateOfBirthCell configureWithTitle:NSLocalizedString(@"personal.profile.date.of.birth.label", nil) value:@""];

    NSMutableArray *addressCells = [NSMutableArray array];

    TextEntryCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"personal.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    TextEntryCell *postCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"personal.profile.post.code.label", nil) value:@""];

    TextEntryCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"personal.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    CountrySelectionCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:TWCountrySelectionCellIdentifier];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"personal.profile.country.label", nil) value:@""];

    [self setPresentedCells:@[@[self.buttonCell], personalCells, addressCells]];

    [self.footerButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:NSLocalizedString(@"personal.profile.controller.title", nil)];

    if ([Credentials userLoggedIn]) {
        [self pullUserDetails];
    } else {
        [self pullCountries];
    }
}

- (void)pullCountries {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.countries.message", nil)];

    [[TransferwiseClient sharedClient] updateCountriesWithCompletionHandler:^(NSArray *countries, NSError *error) {
        [hud hide];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.countries.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"personal.profile.countries.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
            return;
        }

        [self.countryCell setAllCountries:countries];
        [self setPresentedSectionCells:self.presentedCells];
        [self.tableView setTableFooterView:self.footer];
        [self.tableView reloadData];
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kButtonSection) {
        return nil;
    }

    if (section == kPersonalSection) {
        return NSLocalizedString(@"personal.profile.personal.section.title", nil);
    } else {
        return NSLocalizedString(@"personal.profile.address.section.title", nil);
    }
}

- (void)pullUserDetails {
    if ([self.countryCell.allCountries count] > 0) {
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.message", nil)];

    [[TransferwiseClient sharedClient] updateCountriesWithCompletionHandler:^(NSArray *countries, NSError *error) {
        if (error) {
            [hud hide];
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"personal.profile.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];
            return;
        }

        [self.countryCell setAllCountries:countries];

        [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(ProfileDetails *result, NSError *userError) {
            [hud hide];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (userError) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.refresh.error.title", nil)
                                                                       message:NSLocalizedString(@"personal.profile.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }

                [self setPresentedSectionCells:self.presentedCells];
                [self setUserDetails:result];
                [self loadDetailsToCells];
                [self.tableView setTableFooterView:self.footer];
                [self.tableView reloadData];
            });
        }];
    }];
}

- (void)loadDetailsToCells {
    PersonalProfile *profile = self.userDetails.personalProfile;
    [self.firstNameCell setValue:profile.firstName];
    [self.lastNameCell setValue:profile.lastName];
    [self.emailCell setValue:self.userDetails.email];
    [self.phoneNumberCell setValue:profile.phoneNumber];
    [self.dateOfBirthCell setValue:profile.dateOfBirthString];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.postCodeCell setValue:profile.postCode];
    [self.cityCell setValue:profile.city];
    [self.countryCell setValue:profile.countryCode];

    [self.firstNameCell setEditable:![profile identityVerifiedValue]];
    [self.lastNameCell setEditable:![profile identityVerifiedValue]];
    [self.dateOfBirthCell setEditable:![profile identityVerifiedValue]];

    [self.addressCell setEditable:![profile addressVerifiedValue]];
    [self.postCodeCell setEditable:![profile addressVerifiedValue]];
    [self.cityCell setEditable:![profile addressVerifiedValue]];
    [self.countryCell setEditable:![profile addressVerifiedValue]];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != kButtonSection) {
        return;
    }

    PhoneBookProfileSelector *selector = [[PhoneBookProfileSelector alloc] init];
    [self setProfileSelector:selector];
    [selector presentOnController:self completionHandler:^(PhoneBookProfile *profile) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MCLog(@"Did load:%@", profile);
            self.firstNameCell.value = profile.firstName;
            self.lastNameCell.value = profile.lastName;
            self.emailCell.value = profile.email;
            self.phoneNumberCell.value = profile.phone;
            [self.dateOfBirthCell setDateValue:profile.dateOfBirth];

            PhoneBookAddress *address = profile.address;
            self.addressCell.value = address.street;
            self.postCodeCell.value = address.zipCode;
            self.cityCell.value = address.city;
            [self.countryCell setTwoLetterCountryCode:address.countryCode];
        });
    }];
}

- (IBAction)footerButtonPressed:(id)sender {
    [UIApplication dismissKeyboard];

    if (![self inputValid]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
                                                           message:NSLocalizedString(@"personal.profile.validation.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    if (![self valuesChanged]) {
        MCLog(@"Values not changed");
        self.afterSaveAction();
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    if ([Credentials userLoggedIn]) {
        [hud setMessage:NSLocalizedString(@"personal.profile.saving.message", nil)];
    } else {
        [hud setMessage:NSLocalizedString(@"personal.profile.verify.message", nil)];
    }

    PersonalProfile *profile = [[PersonalProfile alloc] init];
    profile.firstName = self.firstNameCell.value;
    profile.lastName = self.lastNameCell.value;
    profile.phoneNumber = self.phoneNumberCell.value;
    profile.addressFirstLine = self.addressCell.value;
    profile.postCode = self.postCodeCell.value;
    profile.city = self.cityCell.value;
    profile.countryCode = self.countryCell.value;
    profile.dateOfBirthString = [self.dateOfBirthCell value];

    SavePersonalProfileOperation *operation = [SavePersonalProfileOperation operationWithProfile:profile];
    [self setExecutedOperation:operation];

    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        [hud hide];

        if (error) {
            NSString *title;
            if ([Credentials userLoggedIn]) {
                title = NSLocalizedString(@"personal.profile.save.error.title", nil);
            } else {
                title = NSLocalizedString(@"personal.profile.verify.error.title", nil);
            }
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:title error:error];
            [alertView show];
            return;
        }

        if (![Credentials userLoggedIn]) {
            ProfileDetails *details = self.userDetails;
            if (!details) {
                details = [[ProfileDetails alloc] init];
            }
            [details setEmail:self.emailCell.value];
            [details setPersonalProfile:profile];
            [self setUserDetails:details];
        } else {
            [self setUserDetails:result];
        }

        [self loadDetailsToCells];

        self.afterSaveAction();
    }];

    [operation execute];
}

- (BOOL)valuesChanged {
    PersonalProfile *profile = self.userDetails.personalProfile;

    return ![[self.firstNameCell value] isEqualToString:profile.firstName]
            || ![[self.lastNameCell value] isEqualToString:profile.lastName]
            || ![[self.emailCell value] isEqualToString:self.userDetails.email]
            || ![[self.phoneNumberCell value] isEqualToString:profile.phoneNumber]
            || ![[self.dateOfBirthCell value] isEqualToString:profile.dateOfBirthString]
            || ![[self.addressCell value] isEqualToString:profile.addressFirstLine]
            || ![[self.postCodeCell value] isEqualToString:profile.postCode]
            || ![[self.cityCell value] isEqualToString:profile.city]
            || ![[self.countryCell value] isEqualToString:profile.countryCode];
}

- (BOOL)inputValid {
    return [[self.firstNameCell value] hasValue] && [[self.lastNameCell value] hasValue] && [[self.emailCell value] hasValue]
            && [[self.phoneNumberCell value] hasValue] && [[self.dateOfBirthCell value] hasValue]
            && [[self.addressCell value] hasValue] && [[self.postCodeCell value] hasValue] && [[self.cityCell value] hasValue]
            && [[self.countryCell value] hasValue];
}

@end
