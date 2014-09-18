//
//  PaymentProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfilesEditViewController.h"
#import "PersonalProfileSource.h"
#import "PersonalProfileViewController.h"
#import "BusinessProfileViewController.h"
#import "TransferBackButtonItem.h"
#import "Credentials.h"
#import "TransferwiseClient.h"
#import "NewPaymentViewController.h"
#import "ConnectionAwareViewController.h"
#import "PersonalProfileCommitter.h"
#import "BusinessProfileCommitter.h"
#import "GoogleAnalytics.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "SettingsViewController.h"

@interface ProfilesEditViewController()

@property (nonatomic, strong) PersonalProfileViewController* personalProfile;
@property (nonatomic, strong) BusinessProfileViewController* businessProfile;
@property (nonatomic) BOOL isShowingSettings;

@end

@implementation ProfilesEditViewController

- (id)init
{
	self = [super init];
	if (self)
	{
		[self setTitle:NSLocalizedString([@"profile.edit.title" deviceSpecificLocalization], nil)];
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 98, 44)];
		[button addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
		[button setImage:[UIImage imageNamed:@"SettingsButton"] forState:UIControlStateNormal];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, 58, 0, -17)];
		UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:button];
		[self.navigationItem setRightBarButtonItem:settingsButton];
	}
	
	return self;
}

- (void)viewDidLoad
{
	self.showFullWidth = YES;
	
	[self initControllers];
	
	NSArray *controllers = @[self.personalProfile, self.businessProfile];
	NSArray *titles = @[NSLocalizedString(@"profile.edit.personal", nil), NSLocalizedString(@"profile.edit.business", nil)];
	
	[super configureWithControllers:controllers
							 titles:titles];
	
	[super viewDidLoad];
}

- (void)initControllers
{
	self.personalProfile = [[PersonalProfileViewController alloc] initWithActionButtonTitle:NSLocalizedString(@"profile.edit.save", nil)
																				 isExisting:YES
																doNotShowMessageForExisting:NO];
	self.personalProfile.objectModel = self.objectModel;
	self.personalProfile.allowProfileSwitch = NO;
	PersonalProfileCommitter *personalValidation = [[PersonalProfileCommitter alloc] init];
	personalValidation.objectModel = self.objectModel;
	self.personalProfile.profileValidation = personalValidation;
	self.personalProfile.showInsideTabControllerForIpad = YES;
	self.personalProfile.showFooterViewForIpad = YES;
	
	self.businessProfile = [[BusinessProfileViewController alloc] initWithActionButtonTitle:NSLocalizedString(@"profile.edit.save", nil)];
	self.businessProfile.objectModel = self.objectModel;
	BusinessProfileCommitter *businessValidation = [[BusinessProfileCommitter alloc] init];
	businessValidation.objectModel = self.objectModel;
	self.businessProfile.profileValidation = businessValidation;
	self.businessProfile.isExisting = YES;
	self.businessProfile.showInsideTabControllerForIpad = YES;
	self.businessProfile.showFooterViewForIpad = YES;
}

- (void)actionTappedWithController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if (controller == self.personalProfile)
	{
		[self.personalProfile validateProfile];
	}
	else if(controller == self.businessProfile)
	{
		[self.businessProfile validateProfile];
	}
}

- (void)willSelectViewController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if (controller == self.personalProfile)
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Personal profile"];
	}
	else if(controller == self.businessProfile)
	{
		[[GoogleAnalytics sharedInstance] sendScreen:@"Business profile"];
	}
}

- (void)showSettings
{
	if (self.isShowingSettings)
	{
		return;
	}
	
	self.isShowingSettings = YES;
	[self.view endEditing:YES];
    SettingsViewController* controller = [[SettingsViewController alloc] init];
	controller.delegate = self;
    controller.objectModel = self.objectModel;
    [controller presentOnViewController:self.view.window.rootViewController];
}

- (void)modalClosed
{
	self.isShowingSettings = NO;
}

- (void)clearData
{
	[self.personalProfile clearData];
	[self.businessProfile clearData];
}
@end
