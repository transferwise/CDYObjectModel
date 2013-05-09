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

static NSUInteger const kDetailsSection = 0;

@interface BusinessProfileViewController ()

@property (nonatomic, strong) NSArray *presentedCells;

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];
    
    NSMutableArray *businessCells = [NSMutableArray array];
    
    TextEntryCell *businessNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setBusinessNameCell:businessNameCell];
    [businessCells addObject:businessNameCell];
    [businessNameCell configureWithTitle:NSLocalizedString(@"business.profile.name.label", nil) value:@""];
    
    TextEntryCell *registrationNumberCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setRegistrationNumberCell:registrationNumberCell];
    [businessCells addObject:registrationNumberCell];
    [registrationNumberCell configureWithTitle:NSLocalizedString(@"business.profile.registration.number.label", nil) value:@""];
    
    TextEntryCell *descriptionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setDescriptionCell:descriptionCell];
    [businessCells addObject:descriptionCell];
    [descriptionCell configureWithTitle:NSLocalizedString(@"business.profile.description.label", nil) value:@""];
    
    NSMutableArray *addressCells = [NSMutableArray array];
    
    TextEntryCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"business.profile.address.label", nil) value:@""];
    
    TextEntryCell *postCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"business.profile.post.code.label", nil) value:@""];
    
    TextEntryCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"business.profile.city.label", nil) value:@""];
    
    CountrySelectionCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:TWCountrySelectionCellIdentifier];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"business.profile.country.label", nil) value:@""];
    
    [self.footerButton setTitle:NSLocalizedString(@"business.profile.save.button.title", nil) forState:UIControlStateNormal];
    
    [self setPresentedCells:@[businessCells, addressCells]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:NSLocalizedString(@"business.profile.controller.title", nil)];
    
    [self pullUserDetails];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.userDetails) {
        return 0;
    }
    
    return [self.presentedCells count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == kDetailsSection) {
        return NSLocalizedString(@"business.profile.details.section.title", nil);
    } else {
        return NSLocalizedString(@"buisiness.profile.address.section.title", nil);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.userDetails) {
        return 0;
    }
    
    NSArray *sectionCells = self.presentedCells[(NSUInteger) section];
    return [sectionCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellAtIndexPath:indexPath];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TextEntryCell *cell = [self cellAtIndexPath:indexPath];
    [cell.entryField becomeFirstResponder];
}

- (TextEntryCell *)cellAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;
    return self.presentedCells[section][row];
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
                
                [self setPresentedSectionCells:self.presentedCells];
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

- (void)viewDidUnload {
    [self setFooterView:nil];
    [self setFooterButton:nil];
    [super viewDidUnload];
}
@end
