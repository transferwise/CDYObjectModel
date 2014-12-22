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
#import"ConnectionAwareViewController.h"
#import "MOMStyle.h"
#import "TouchIDHelper.h"

#define ABOUT_URL	@"https://transferwise.com/en/about"

NSString *const kSettingsTitleCellIdentifier = @"kSettingsTitleCellIdentifier";

@interface SettingsViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *customerServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendAsBusinessLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sendAsBusinessSwitch;
@property (weak, nonatomic) IBOutlet UIButton *touchIdButton;

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
    [[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:@"Settings"]];

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
    [self.touchIdButton setTitle:NSLocalizedString(@"settings.row.touchid",nil) forState:UIControlStateNormal];
    self.touchIdButton.hidden = (![TouchIDHelper isTouchIdAvailable] || ((![TouchIDHelper isTouchIdSlotTaken]) && [TouchIDHelper isBlockedUserNameListEmpty]));
    
    self.sendAsBusinessLabel.text = NSLocalizedString(@"settings.row.send.as.business",nil);
    User *user = [self.objectModel currentUser];
    [self.sendAsBusinessSwitch setOnTintColor:[UIColor colorFromStyle:@"TWElectricBlue"]];
    self.sendAsBusinessSwitch.on = user.sendAsBusinessDefaultSettingValue;
}

- (IBAction)infoTapped:(id)sender
{
	NSURL *url = [NSURL URLWithString:ABOUT_URL];
	[[UIApplication sharedApplication] openURL:url];
}

- (IBAction)customerServiceTapped:(id)sender
{
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"ContactSupport" withLabel:@"Settings"];
	[[SupportCoordinator sharedInstance] presentOnController:IPAD ? self : self.hostViewController];
}

- (IBAction)feedbackTapped:(id)sender {
    [[FeedbackCoordinator sharedInstance] presentFeedbackEmail];
}

- (IBAction)logOutTapped:(id)sender
{
	[self dismiss];
	[[NSNotificationCenter defaultCenter] postNotificationName:TRWLoggedOutNotification object:nil];
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
	if (IOS_8)
	{
		//alignment for iOS8
		CGSize totalSize = button.frame.size;
		button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), (totalSize.width / 2) - (imageSize.width / 2) - 8, 0.0, -     titleSize.width);
	}
	else
	{
		button.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, -     titleSize.width);
	}
}

- (IBAction)profileUseSwitched:(id)sender
{
    User *user = [self.objectModel currentUser];
    user.sendAsBusinessDefaultSettingValue = self.sendAsBusinessSwitch.on;
    [self.objectModel saveContext];
}

- (IBAction)touchIdButtonTapped:(id)sender
{
    if([TouchIDHelper isTouchIdSlotTaken])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"touchid.alert.title",nil) message:NSLocalizedString(@"touchid.settings.clear.info",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"button.title.no",nil) otherButtonTitles:NSLocalizedString(@"button.title.yes",nil), nil];
        alertView.tag = 1;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"touchid.alert.title",nil) message:NSLocalizedString(@"touchid.settings.names.info",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"button.title.cancel",nil) otherButtonTitles:NSLocalizedString(@"touchid.settings.names.title",nil), nil];
        alertView.tag = 2;
        [alertView show];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        return;
    }
    if(alertView.tag == 1)
    {
        [TouchIDHelper clearCredentialsAfterValidation:^(BOOL success) {
            if(success)
            {
                self.touchIdButton.hidden = YES;
            }
        }];
    }
    else
    {
        [TouchIDHelper clearBlockedUsernames];
        self.touchIdButton.hidden = YES;
    }
}

@end
