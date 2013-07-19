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
#import "Credentials.h"
#import "TRWAlertView.h"
#import "TransferwiseClient.h"
#import "PhoneBookProfileSelector.h"
#import "TRWProgressHUD.h"
#import "PhoneBookProfile.h"
#import "ObjectModel.h"
#import "UIApplication+Keyboard.h"
#import "PlainPersonalProfileInput.h"
#import "ObjectModel+Countries.h"

static NSUInteger const kButtonSection = 0;

@interface ProfileEditViewController ()

@property (nonatomic, strong) ProfileSource *profileSource;
@property (nonatomic, strong) ButtonCell *buttonCell;
@property (nonatomic, strong) IBOutlet UIView *footer;
@property (nonatomic, strong) IBOutlet UIButton *footerButton;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) NSArray *presentationCells;
@property (nonatomic, strong) PhoneBookProfileSelector *profileSelector;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;

- (IBAction)footerButtonPressed:(id)sender;

@end

@implementation ProfileEditViewController

- (id)initWithSource:(ProfileSource *)source {
    self = [super initWithNibName:@"ProfileEditViewController" bundle:nil];
    if (self) {
        _profileSource = source;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.tableView registerNib:[UINib nibWithNibName:@"ButtonCell" bundle:nil] forCellReuseIdentifier:TWButtonCellIdentifier];

    self.buttonCell = [self.tableView dequeueReusableCellWithIdentifier:TWButtonCellIdentifier];
    self.buttonCell.textLabel.text = NSLocalizedString(@"button.title.import.from.phonebook", nil);

    [self.profileSource setTableView:self.tableView];


    [self createPresentationCells];

    [self.footerButton setTitle:self.footerButtonTitle forState:UIControlStateNormal];
}

- (void)createPresentationCells {
    NSMutableArray *presented = [NSMutableArray array];
    [presented addObject:@[self.buttonCell]];
    [presented addObjectsFromArray:[self.profileSource presentedCells]];

    UITableViewCell *countryCell = nil;
    for (NSArray *cells in presented) {
        for (UITableViewCell *cell in cells) {
            if ([cell isKindOfClass:[CountrySelectionCell class]]) {
                countryCell = cell;
                break;
            }
        }

        if (countryCell) {
            break;
        }
    }
    [self setCountryCell:(CountrySelectionCell *) countryCell];
    [self.countryCell setAllCountries:[self.objectModel fetchedControllerForAllCountries]];

    [self setPresentationCells:presented];
}

- (void)setObjectModel:(ObjectModel *)objectModel {
    _objectModel = objectModel;
    [self.profileSource setObjectModel:objectModel];
}

- (void)setPresentProfileSource:(ProfileSource *)source reloadView:(BOOL)reload {
    [source setObjectModel:self.objectModel];
    [self setProfileSource:source];
    [self.profileSource setTableView:self.tableView];
    [self.navigationItem setTitle:[self.profileSource editViewTitle]];
    [self createPresentationCells];

    if (!reload) {
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.message", nil)];

    [self.profileSource pullDetailsWithHandler:^(NSError *profileError) {
        [hud hide];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (profileError) {
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.refresh.error.title", nil)
                                                                   message:NSLocalizedString(@"personal.profile.refresh.error.message", nil)];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alertView show];
                return;
            }

            [self setPresentedSectionCells:self.presentationCells];
            [self.tableView setTableFooterView:self.footer];
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationItem setTitle:[self.profileSource editViewTitle]];

    if ([Credentials userLoggedIn]) {
        [self pullDetails];
    } else {
        [self pullCountries];
    }
}

- (void)pullCountries {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.countries.message", nil)];

    [self pullCountriesWithHud:hud completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self setPresentedSectionCells:self.presentationCells];
            [self.tableView setTableFooterView:self.footer];
            [self.tableView reloadData];
        });
    }];

}

- (void)pullCountriesWithHud:(TRWProgressHUD *)hud completionHandler:(JCSActionBlock)completion {
    CountriesOperation *operation = [CountriesOperation operation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];
    [operation setCompletionHandler:^(NSError *error) {
        if (error) {
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

- (void)pullDetails {
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.refreshing.message", nil)];

    [self pullCountriesWithHud:hud completionHandler:^{
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

                [self setPresentedSectionCells:self.presentationCells];
                [self.tableView setTableFooterView:self.footer];
                [self.tableView reloadData];
            });
        }];

    }];
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != kButtonSection) {
        return;
    }

    PhoneBookProfileSelector *selector = [[PhoneBookProfileSelector alloc] init];
    [self setProfileSelector:selector];
    [selector presentOnController:self completionHandler:^(PhoneBookProfile *profile) {
        [self.profileSource loadDataFromProfile:profile];
    }];
}

- (IBAction)footerButtonPressed:(id)sender {
    [UIApplication dismissKeyboard];

    if (![self.profileSource inputValid]) {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"personal.profile.validation.error.title", nil)
                                                           message:NSLocalizedString(@"personal.profile.validation.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }

    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"personal.profile.verify.message", nil)];
    
    PlainPersonalProfileInput *profile = [self.profileSource enteredProfile];

    [self.profileSource validateProfile:profile withValidation:self.profileValidation completion:^(NSError *error) {
        [hud hide];

        if (error) {
            TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"personal.profile.verify.error.title", nil) error:error];
            [alertView show];
        }
    }];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.profileSource titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


@end
