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
#import "GoogleAnalytics.h"
#import "NewPaymentViewController.h"
#import"ConnectionAwareViewController.h"

NSString *const kSettingsTitleCellIdentifier = @"kSettingsTitleCellIdentifier";


@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *customerServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

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

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.customerServiceButton setTitle:NSLocalizedString(@"settings.row.contact.support",nil) forState:UIControlStateNormal];
    [self.feedbackButton setTitle:NSLocalizedString(@"settings.row.contact.support",nil) forState:UIControlStateNormal];
    [self.logOutButton setTitle:NSLocalizedString(@"settings.row.contact.support",nil) forState:UIControlStateNormal];
    [self.infoButton setTitle:NSLocalizedString(@"settings.row.contact.support",nil) forState:UIControlStateNormal];
}


- (IBAction)infoTapped:(id)sender {
}

- (IBAction)customerServiceTapped:(id)sender {
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"menu"];
    [[SupportCoordinator sharedInstance] presentOnController:self.hostViewController];
}

- (IBAction)feedbackTapped:(id)sender {
    [[FeedbackCoordinator sharedInstance] presentFeedbackEmail];
}

- (IBAction)logOutTapped:(id)sender {
    [[TransferwiseClient sharedClient] clearCredentials];
	
	NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
	[controller setObjectModel:self.objectModel];
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	[navigationController setNavigationBarHidden:YES];
	ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
	[self.hostViewController presentViewController:wrapper animated:YES completion:nil];
    [self dismiss];

}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SettingsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTitleCellIdentifier];
//    [cell.imageView setImage:nil];
//    [cell.textLabel setTextColor:[UIColor whiteColor]];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
//
//    SettingsRow code = (SettingsRow) [self.presentedRows[(NSUInteger) indexPath.row] shortValue];
//    switch (code) {
//        case LogoutRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.logout", nil)];
//            break;
//        case UserProfileRow:
//            [cell setTitle:[self.objectModel.currentUser displayName]];
//            [cell.imageView setImage:[UIImage imageNamed:@"ProfileIcon.png"]];
//            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            break;
//        case PersonalProfileRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.personal.profile", nil)];
//            break;
//        case BusinessProfileRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.business.profile", nil)];
//            break;
//        case SignUpRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.signup", nil)];
//            break;
//        case LogInRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.log.in", nil)];
//            break;
//        case FillerRow:
//            [cell setTitle:@""];
//            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//            break;
//        case ClaimAccountRow:
//            [cell setTitle:NSLocalizedString(@"settings.row.claim.account", nil)];
//            break;
//        case ContactSupport:
//            [cell setTitle:NSLocalizedString(@"settings.row.contact.support", nil)];
//            break;
//        case SendFeedback:
//            [cell setTitle:NSLocalizedString(@"settings.row.send.feedback", nil)];
//            break;
//        default:
//            [cell setTitle:@"Unknown case..."];
//    }
//
//    return cell;
//}





@end
