//
//  SettingsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTitleCell.h"
#import "UIColor+Theme.h"
#import "Credentials.h"
#import "PersonalProfileViewController.h"
#import "BusinessProfileViewController.h"
#import "SWRevealViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "PersonalProfileCommitter.h"
#import "ClaimAccountViewController.h"
#import "BusinessProfileCommitter.h"
#import "TransferwiseClient.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "SupportCoordinator.h"
#import "FeedbackCoordinator.h"

NSString *const kSettingsTitleCellIdentifier = @"kSettingsTitleCellIdentifier";

typedef NS_ENUM(short, SettingsRow) {
    LogoutRow,
    UserProfileRow,
    PersonalProfileRow,
    BusinessProfileRow,
    SignUpRow,
    FillerRow,
    LogInRow,
    ClaimAccountRow,
    ContactSupport,
    SendFeedback
};

@interface SettingsViewController ()

@property (nonatomic, strong) NSArray *presentedRows;

@end

@implementation SettingsViewController

- (id)init {
    self = [super initWithNibName:@"SettingsViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTitleCell" bundle:nil] forCellReuseIdentifier:kSettingsTitleCellIdentifier];

    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor settingsBackgroundColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSMutableArray *presented = [NSMutableArray array];
    if ([Credentials userLoggedIn]) {
        [presented addObject:@(UserProfileRow)];
        [presented addObject:@(ContactSupport)];
        [presented addObject:@(SendFeedback)];
        [presented addObject:@(PersonalProfileRow)];
        [presented addObject:@(BusinessProfileRow)];
        if ([Credentials temporaryAccount]) {
            [presented addObject:@(ClaimAccountRow)];
        }
        [presented addObject:@(FillerRow)];
        [presented addObject:@(LogoutRow)];
    } else {
        [presented addObject:@(ContactSupport)];
        [presented addObject:@(LogInRow)];
        [presented addObject:@(SignUpRow)];
    }

    [self setPresentedRows:presented];
    [self.tableView reloadData];

    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    [self.navigationItem setLeftBarButtonItem:cancel];
}

- (void)cancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.presentedRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTitleCellIdentifier];
    [cell.imageView setImage:nil];
    [cell.textLabel setTextColor:[UIColor whiteColor]];

    SettingsRow code = (SettingsRow) [self.presentedRows[(NSUInteger) indexPath.row] shortValue];
    switch (code) {
        case LogoutRow:
            [cell setTitle:NSLocalizedString(@"settings.row.logout", nil)];
            break;
        case UserProfileRow:
            [cell setTitle:[self.objectModel.currentUser displayName]];
            [cell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            break;
        case PersonalProfileRow:
            [cell setTitle:NSLocalizedString(@"settings.row.personal.profile", nil)];
            break;
        case BusinessProfileRow:
            [cell setTitle:NSLocalizedString(@"settings.row.business.profile", nil)];
            break;
        case SignUpRow:
            [cell setTitle:NSLocalizedString(@"settings.row.signup", nil)];
            break;
        case LogInRow:
            [cell setTitle:NSLocalizedString(@"settings.row.log.in", nil)];
            break;
        case FillerRow:
            [cell setTitle:@""];
            break;
        case ClaimAccountRow:
            [cell setTitle:NSLocalizedString(@"settings.row.claim.account", nil)];
            break;
        case ContactSupport:
            [cell setTitle:NSLocalizedString(@"settings.row.contact.support", nil)];
            break;
        case SendFeedback:
            [cell setTitle:NSLocalizedString(@"settings.row.send.feedback", nil)];
            break;
        default:
            [cell setTitle:@"Unknown case..."];
    }

    return cell;
}

#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *row = self.presentedRows[indexPath.row];
    if ([row shortValue] == UserProfileRow || [row shortValue] == FillerRow) {
        return nil;
    }

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SWRevealViewController *revealController = [self revealViewController];
    //TODO jaanus: check if can get rid of this line
    UINavigationController *pushOnNavigationController = (UINavigationController*)revealController.frontViewController;

    //TODO jaanus: check if can get rid of [revealController revealToggle:nil] call

    SettingsRow code = (SettingsRow) [self.presentedRows[(NSUInteger) indexPath.row] shortValue];
    switch (code) {
        case LogoutRow:
            [[TransferwiseClient sharedClient] clearCredentials];
            [revealController revealToggle:nil];
            [revealController.frontViewController viewDidAppear:YES];
            break;
        case SignUpRow: {
            SignUpViewController *controller = [[SignUpViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [pushOnNavigationController pushViewController:controller animated:YES];
            [revealController revealToggle:nil];
            break;
        }
        case PersonalProfileRow: {
            PersonalProfileViewController *controller = [[PersonalProfileViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [controller setFooterButtonTitle:NSLocalizedString(@"personal.profile.save.button.title", nil)];
            PersonalProfileCommitter *validation = [[PersonalProfileCommitter alloc] init];
            [validation setObjectModel:self.objectModel];
            [controller setProfileValidation:validation];
            [revealController revealToggle:nil];
            [pushOnNavigationController pushViewController:controller animated:YES];
            break;
        }
        case BusinessProfileRow: {
            BusinessProfileViewController *controller = [[BusinessProfileViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [controller setFooterButtonTitle:NSLocalizedString(@"business.profile.save.button.title", nil)];
            BusinessProfileCommitter *validation = [[BusinessProfileCommitter alloc] init];
            [validation setObjectModel:self.objectModel];
            [controller setProfileValidation:validation];
            [revealController revealToggle:nil];
            [pushOnNavigationController pushViewController:controller animated:YES];
            break;
        }
        case LogInRow: {
            LoginViewController *controller = [[LoginViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [self.navigationController pushViewController:controller animated:YES];
            [revealController revealToggle:nil];
            [pushOnNavigationController pushViewController:controller animated:YES];
        }
            break;
        case ClaimAccountRow: {
            ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
            [revealController revealToggle:nil];
            [pushOnNavigationController pushViewController:controller animated:YES];
            break;
        }
        case ContactSupport: {
            [[SupportCoordinator sharedInstance] presentOnController:self];
            break;
        }
        case SendFeedback: {
            [[FeedbackCoordinator sharedInstance] presentFeedbackAlert];
            break;
        }
        default:
            NSLog(@"Unhandled row code %d", code);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *row = self.presentedRows[indexPath.row];
    CGFloat rowHeight = self.tableView.rowHeight;
    if ([row shortValue] != FillerRow) {
        return rowHeight;
    }

    CGFloat filledRows = ([self.presentedRows count] - 1) * rowHeight;
    CGFloat fillHeight = CGRectGetHeight(self.tableView.frame) - filledRows;
    return fillHeight;
}


@end
