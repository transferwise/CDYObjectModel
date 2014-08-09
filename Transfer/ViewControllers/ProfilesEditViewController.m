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

@interface ProfilesEditViewController ()

@property (nonatomic, strong) PersonalProfileViewController* personalProfile;
@property (nonatomic, strong) BusinessProfileViewController* businessProfile;

@end

@implementation ProfilesEditViewController

- (void)viewDidLoad
{
	self.showButtonForIpad = YES;
	self.showFullWidth = YES;
	
	[self initControllers];
	NSArray *controllers, *titles;
	
	if (self.allowProfileSwitch && [Credentials userLoggedIn])
	{
		controllers = @[self.personalProfile, self.businessProfile];
		titles = @[NSLocalizedString(@"profile.selection.text.personal.profile", nil), NSLocalizedString(@"profile.selection.text.business.profile", nil)];
	}
	else
	{
		controllers = @[self.personalProfile];
		titles = @[NSLocalizedString(@"profile.selection.text.personal.profile", nil)];

	}
	
	[super configureWithControllers:controllers
							 titles:titles
						actionTitle:self.buttonTitle ? self.buttonTitle :  NSLocalizedString(@"confirm.payment.footer.button.title", nil)
						actionStyle:@"greenButton"
					   actionShadow:@"greenShadow"
					 actionProgress:0.3f];
    [super viewDidLoad];
	
	[self setTitle:NSLocalizedString(@"personal.profile.controller.title", nil)];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
}

- (void)initControllers
{
	self.personalProfile = [[PersonalProfileViewController alloc] init];
	self.personalProfile.objectModel = self.objectModel;
	self.personalProfile.allowProfileSwitch = self.allowProfileSwitch;
	
	if(self.profileValidation)
	{
		self.personalProfile.profileValidation = self.profileValidation;
	}
	
	if (self.allowProfileSwitch)
	{
		self.businessProfile = [[BusinessProfileViewController alloc] init];
		self.businessProfile.objectModel = self.objectModel;
		
		if(self.profileValidation)
		{
			self.businessProfile.profileValidation = self.profileValidation;
		}
	}
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

- (void)logOut
{
	//moved here from MainViewController
	//TODO: remove to actual logout action
	[[TransferwiseClient sharedClient] clearCredentials];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Cleared credentials!" message:nil delegate:nil cancelButtonTitle:@"Aha!" otherButtonTitles:nil];
	[alert show];
	
	NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
	[controller setObjectModel:self.objectModel];
			
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
	[navigationController setNavigationBarHidden:YES];
	ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
	[self presentViewController:wrapper animated:YES completion:nil];
}
@end
