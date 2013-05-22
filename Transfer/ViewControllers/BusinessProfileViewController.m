//
//  BusinessProfileViewController.m
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileViewController.h"
#import "BusinessProfile.h"
#import "ProfileDetails.h"
#import "TextEntryCell.h"
#import "TransferwiseClient.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "UIColor+Theme.h"
#import "SaveBusinessProfileOperation.h"
#import "CountrySelectionCell.h"
#import "BlueButton.h"
#import "UIApplication+Keyboard.h"
#import "NSString+Validation.h"
#import "ButtonCell.h"
#import "PhoneBookProfileSelector.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"

static NSUInteger const kButtonSection = 0;
static NSUInteger const kDetailsSection = 1;

@interface BusinessProfileViewController ()

@property (nonatomic, strong) ButtonCell *buttonCell;
@property (nonatomic, strong) TextEntryCell *businessNameCell;
@property (nonatomic, strong) TextEntryCell *registrationNumberCell;
@property (nonatomic, strong) TextEntryCell *descriptionCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) TextEntryCell *postCodeCell;
@property (nonatomic, strong) TextEntryCell *cityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet BlueButton *footerButton;
@property (nonatomic, strong) NSArray *businessCells;
@property (nonatomic, strong) NSArray *addressCells;
@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;

@end

@implementation BusinessProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithNibName:@"BusinessProfileViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:TWButtonCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];

    self.buttonCell = [self.tableView dequeueReusableCellWithIdentifier:TWButtonCellIdentifier];
    self.buttonCell.textLabel.text = NSLocalizedString(@"button.title.import.from.phonebook", nil);

    NSMutableArray *businessCells = [NSMutableArray array];
    
    TextEntryCell *businessNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setBusinessNameCell:businessNameCell];
    [businessCells addObject:businessNameCell];
    [businessNameCell configureWithTitle:NSLocalizedString(@"business.profile.name.label", nil) value:@""];
    [businessNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    
    TextEntryCell *registrationNumberCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setRegistrationNumberCell:registrationNumberCell];
    [businessCells addObject:registrationNumberCell];
    [registrationNumberCell configureWithTitle:NSLocalizedString(@"business.profile.registration.number.label", nil) value:@""];
    
    TextEntryCell *descriptionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setDescriptionCell:descriptionCell];
    [businessCells addObject:descriptionCell];
    [descriptionCell configureWithTitle:NSLocalizedString(@"business.profile.description.label", nil) value:@""];
    [descriptionCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    [self setBusinessCells:businessCells];
    
    NSMutableArray *addressCells = [NSMutableArray array];
    
    TextEntryCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"business.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    
    TextEntryCell *postCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"business.profile.post.code.label", nil) value:@""];
    
    TextEntryCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"business.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    
    CountrySelectionCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:TWCountrySelectionCellIdentifier];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"business.profile.country.label", nil) value:@""];
    
    [self.footerButton setTitle:NSLocalizedString(@"business.profile.save.button.title", nil) forState:UIControlStateNormal];

    [self setAddressCells:addressCells];
}

- (void)viewDidUnload {
    [self setFooterView:nil];
    [self setFooterButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:NSLocalizedString(@"business.profile.controller.title", nil)];

    if ([self.countryCell.allCountries count] > 0) {
        return;
    }

    [self pullUserDetails];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kButtonSection) {
        return nil;
    }

    if (section == kDetailsSection) {
        return NSLocalizedString(@"business.profile.details.section.title", nil);
    } else {
        return NSLocalizedString(@"business.profile.address.section.title", nil);
    }
}

- (void)pullUserDetails {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"business.profile.refreshing.message", nil)];
    
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
    
        [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(ProfileDetails *result, NSError *error) {
            [hud hide];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"business.profile.refresh.error.title", nil)
                                                                       message:NSLocalizedString(@"business.profile.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }
                
                [self setPresentedSectionCells:@[@[self.buttonCell], self.businessCells, self.addressCells]];
                [self setUserDetails:result];
                [self loadDetailsToCells];
                [self.tableView setTableFooterView:self.footerView];
                [self.tableView reloadData];
                });
            }];
    }];
}

- (void)loadDetailsToCells {
    BusinessProfile *profile = self.userDetails.businessProfile;
    [self.businessNameCell setValue:profile.businessName];
    [self.registrationNumberCell setValue:profile.registrationNumber];
    [self.descriptionCell setValue:profile.descriptionOfBusiness];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.postCodeCell setValue:profile.postCode];
    [self.cityCell setValue:profile.city];
    [self.countryCell setValue:profile.countryCode];
    
    [self.businessNameCell setEditable:![profile businessVerifiedValue]];
    [self.registrationNumberCell setEditable:![profile businessVerifiedValue]];
    [self.descriptionCell setEditable:![profile businessVerifiedValue]];
    
    [self.addressCell setEditable:![profile businessVerifiedValue]];
    [self.postCodeCell setEditable:![profile businessVerifiedValue]];
    [self.cityCell setEditable:![profile businessVerifiedValue]];
    [self.countryCell setEditable:![profile businessVerifiedValue]];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section == kButtonSection) {
        return;
    }

    PhoneBookProfileSelector *selector = [[PhoneBookProfileSelector alloc] init];
    [self setProfileSelector:selector];
    [selector presentOnController:self completionHandler:^(PhoneBookProfile *profile) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.businessNameCell.value = profile.organisation;

            PhoneBookAddress *address = profile.address;
            self.addressCell.value = address.street;
            self.postCodeCell.value = address.zipCode;
            self.cityCell.value = address.city;
            [self.countryCell setTwoLetterCountryCode:address.countryCode];
        });
    }];
}

- (IBAction)footerButtonClicked:(id)sender {
    [UIApplication dismissKeyboard];
    
    if (![self inputValid]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"business.profile.validation.error.title", nil)
                                                           message:NSLocalizedString(@"business.profile.validation.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"businessName"] = [self.businessNameCell value];
    data[@"registrationNumber"] = [self.registrationNumberCell value];
    data[@"descriptionOfBusiness"] = [self.descriptionCell value];
    data[@"addressFirstLine"] = [self.addressCell value];
    data[@"postCode"] = [self.postCodeCell value];
    data[@"city"] = [self.cityCell value];
    data[@"countryCode"] = [self.countryCell value];
    
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
    [hud setMessage:NSLocalizedString(@"business.profile.saving.message", nil)];
    
    SaveBusinessProfileOperation *operation = [SaveBusinessProfileOperation operationWithData:data];
    [self setExecutedOperation:operation];
    
    [operation setSaveResultHandler:^(ProfileDetails *result, NSError *error) {
        [hud hide];
        
        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"business.profile.save.error.title", nil) error:error];
            [alertView show];
            return;
        }
        
        [self setUserDetails:result];
        [self loadDetailsToCells];
    }];
    
    [operation execute];
}

- (BOOL)inputValid {
    return [[self.businessNameCell value] hasValue] && [[self.registrationNumberCell value] hasValue] && [[self.descriptionCell value] hasValue]
    && [[self.addressCell value] hasValue] && [[self.postCodeCell value] hasValue] && [[self.cityCell value] hasValue]
    && [[self.countryCell value] hasValue];
}

@end
