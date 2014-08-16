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

    self.titleLabel.text = NSLocalizedString(@"settings.title",nil);
    
    [self.customerServiceButton setTitle:NSLocalizedString(@"settings.row.contact.support",nil) forState:UIControlStateNormal];
    [self.feedbackButton setTitle:NSLocalizedString(@"settings.row.send.feedback",nil) forState:UIControlStateNormal];
    [self.logOutButton setTitle:NSLocalizedString(@"settings.row.logout",nil) forState:UIControlStateNormal];
    [self.infoButton setTitle:NSLocalizedString(@"settings.row.about",nil) forState:UIControlStateNormal];
    [self verticallyAlignTextAndImageOfButton:self.infoButton];
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
	[self.hostViewController presentViewController:wrapper animated:YES completion:^{
        [self dismiss];
    }];
}

-(void) verticallyAlignTextAndImageOfButton:(UIButton *)button
{
    //If this is ever needed agian, kmove to a category on UIButton and add spacing argument.
    
    CGFloat spacing = 10.0f; // the amount of spacing to appear between image and title
    button.imageView.backgroundColor=[UIColor clearColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    // get the size of the elements here for readability
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height   + spacing), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    titleSize = button.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, -     titleSize.width);
}







@end
