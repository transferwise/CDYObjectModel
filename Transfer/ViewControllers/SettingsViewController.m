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
#import "AuthenticationHelper.h"
#import "SettingsButtonCell.h"
#import "SettingsSwitchCell.h"
#import "TRWProgressHUD.h"

#define ABOUT_URL	@"https://transferwise.com/en/about"

typedef NS_ENUM(short, Setting)
{
    FeedbackSetting,
    CustomerServiceSetting,
    SendAsBusinessSetting,
    TouchIDSetting,
    GoogleSetting
};

NSString *const kSettingsTitleCellIdentifier = @"kSettingsTitleCellIdentifier";

@interface SettingsViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,SettingsButtonDelegate, SettingsSwitchDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pRefLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* settingsFields;

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
    [[GoogleAnalytics sharedInstance] sendScreen:GASettings];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.titleLabel.text = NSLocalizedString(@"settings.title",nil);

    [self.logOutButton setTitle:NSLocalizedString(@"settings.row.logout",nil) forState:UIControlStateNormal];
    [self.infoButton setTitle:NSLocalizedString(@"settings.row.about",nil) forState:UIControlStateNormal];
    
    [self verticallyAlignTextAndImageOfButton:self.infoButton];

    User *user = [self.objectModel currentUser];
    self.pRefLabel.text = user.pReference;
    
    [self refreshSettingsFields];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsButtonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingsButtonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsSwitchCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingsSwitchCell"];
    
    [self updateTableViewInsetsForOrientation:self.interfaceOrientation];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateTableViewInsetsForOrientation:toInterfaceOrientation];
        
}

-(void)updateTableViewInsetsForOrientation:(UIInterfaceOrientation)orientation
{
    if(IPAD)
    {
        if(UIInterfaceOrientationIsPortrait(orientation))
        {
            self.tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
        }
        else
        {
            self.tableView.contentInset = UIEdgeInsetsZero;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting currentSetting = [self.settingsFields[indexPath.row] shortValue];
    if(currentSetting != SendAsBusinessSetting)
    {
        return IPAD?60:55;
    }
    else
    {
        return IPAD?140:80;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingsFields count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title;
    Setting currentSetting = [self.settingsFields[indexPath.row] shortValue];
    switch (currentSetting) {
        case FeedbackSetting:
            title = NSLocalizedString(@"settings.row.send.feedback",nil);
            break;
        case CustomerServiceSetting:
            title = NSLocalizedString(@"settings.row.contact.support",nil);
            break;
        case SendAsBusinessSetting:
            title = NSLocalizedString(@"settings.row.send.as.business",nil);
            break;
        case TouchIDSetting:
            title = NSLocalizedString(@"settings.row.touchid",nil);
            break;
        case GoogleSetting:
            title = NSLocalizedString(@"settings.row.google",nil);
            break;
        default:
            title = @"Send Feedback";
            break;
    }
    
    UITableViewCell *resultCell;
    if(currentSetting != SendAsBusinessSetting)
    {
        SettingsButtonCell* cell = (SettingsButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingsButtonCell" forIndexPath:indexPath];
        [cell.settingsButton setTitle:title forState:UIControlStateNormal];
        cell.settingsButtonDelegate = self;
        resultCell = cell;
    }
    else
    {
        SettingsSwitchCell* cell = (SettingsSwitchCell*)[tableView dequeueReusableCellWithIdentifier:@"SettingsSwitchCell" forIndexPath:indexPath];
        cell.titleLabel.text = title;
        cell.settingsSwitch.on = [self.objectModel currentUser].sendAsBusinessDefaultSettingValue;
        cell.settingsSwitchDelegate = self;
        resultCell = cell;
    }
    
    resultCell.backgroundColor = [UIColor clearColor]; //Fix for iOS7 bug on iPad. Can't be done in awakeFromNib, or I would have...
    return resultCell;
    
}


- (IBAction)infoTapped:(id)sender
{
	NSURL *url = [NSURL URLWithString:ABOUT_URL];
	[[UIApplication sharedApplication] openURL:url];
}

- (IBAction)customerServiceTapped:(id)sender
{
    [[GoogleAnalytics sharedInstance] sendAppEvent:GAContactsupport withLabel:@"Settings"];
	[[SupportCoordinator sharedInstance] presentOnController:IPAD ? self : self.hostViewController];
}

- (IBAction)feedbackTapped:(id)sender {
    [[FeedbackCoordinator sharedInstance] presentFeedbackEmail];
}

- (IBAction)logOutTapped:(id)sender
{
	[self dismiss];
    
    [AuthenticationHelper logOutWithObjectModel:self.objectModel tokenNeedsClearing:YES completionBlock:^{
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
    
    // lower the text and push it left to center it
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height   + spacing), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    CGSize titleSize = button.titleLabel.frame.size;
    
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

-(void)googleSettingsTapped:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"settings.google.alert.title",nil) message:NSLocalizedString(@"settings.google.alert.text",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"button.title.no",nil) otherButtonTitles:NSLocalizedString(@"button.title.yes",nil), nil];
    alertView.tag = 3;
    [alertView show];
}

-(void)refreshSettingsFields
{
    if (!self.settingsFields)
    {
        self.settingsFields = [NSMutableArray arrayWithCapacity:3];
        [self.settingsFields addObjectsFromArray:@[@(CustomerServiceSetting),@(FeedbackSetting),@(SendAsBusinessSetting)]];
    }
    if([TouchIDHelper isTouchIdAvailable] && ([TouchIDHelper isTouchIdSlotTaken] || ![TouchIDHelper isBlockedUserNameListEmpty]))
    {
        if(![self.settingsFields containsObject:@(TouchIDSetting)])
        {
            [self.settingsFields insertObject:@(TouchIDSetting) atIndex:3];
        }
    }
    else
    {
        [self.settingsFields removeObject:@(TouchIDSetting)];
    }
    if([@"google" caseInsensitiveCompare:[self.objectModel currentUser].authenticationProvider] == NSOrderedSame)
    {
        if(![self.settingsFields containsObject:@(GoogleSetting)])
        {
            [self.settingsFields addObject:@(GoogleSetting)];
        }
    }
    else
    {
        [self.settingsFields removeObject:@(GoogleSetting)];
    }
}

-(void)settingsButtonTappedOnCell:(UITableViewCell *)cell
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    if(indexpath.row != NSNotFound)
    {
        Setting setting = [self.settingsFields[indexpath.row] shortValue];
        switch (setting) {
            case CustomerServiceSetting:
                [self customerServiceTapped:cell];
                break;
            case FeedbackSetting:
                [self feedbackTapped:cell];
                break;
            case TouchIDSetting:
                [self touchIdButtonTapped:cell];
                break;
            case GoogleSetting:
                [self googleSettingsTapped:cell];
                break;
            default:
                break;
        }
    }
}

-(void)settingsSwitchToggledOnCell:(UITableViewCell *)cell newValue:(BOOL)newValue
{
    User *user = [self.objectModel currentUser];
    user.sendAsBusinessDefaultSettingValue = newValue;
    [self.objectModel saveContext];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        return;
    }

    if(alertView.tag == 1)
    {
        __weak typeof(self) weakSelf = self;
        [TouchIDHelper clearCredentialsAfterValidation:^(BOOL success) {
            if(success)
            {
                [weakSelf removeTouchId];
            }
        }];
    }
    else if (alertView.tag == 2)
    {
        [TouchIDHelper clearBlockedUsernames];
        [self removeTouchId];
    }
    else
    {
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.view];
        [AuthenticationHelper revokeOauthAccessForProvider:[self.objectModel currentUser].authenticationProvider completionBlock:^{
            [hud hide];
            [self logOutTapped:nil];
        }];
    }
}

-(void)removeTouchId
{
    NSUInteger row = [self.settingsFields indexOfObject:@(TouchIDSetting)];
    if(row != NSNotFound)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView beginUpdates];
        NSUInteger count = [self.settingsFields count];
        [self refreshSettingsFields];
        if (count > [self.settingsFields count])
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
    }
}
@end
