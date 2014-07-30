//
//  PaymentProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentProfileViewController.h"
#import "PersonalProfileSource.h"
#import "PersonalProfileViewController.h"
#import "BusinessProfileViewController.h"
#import "TransferBackButtonItem.h"

@interface PaymentProfileViewController ()

@property (nonatomic, strong) PersonalProfileViewController* personalProfile;
@property (nonatomic, strong) BusinessProfileViewController* businessProfile;

@end

@implementation PaymentProfileViewController

- (void)viewDidLoad
{
	[self initControllers];
	NSArray *controllers, *titles;
	
	if (self.allowProfileSwitch)
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
						actionTitle:self.buttonTitle ? self.buttonTitle :  NSLocalizedString(@"confirm.payment.footer.button.title", nil)];
    [super viewDidLoad];
	//do this after supers viewDidLoad because the decision to show header must be made
	[self setHeightOffsets:self.heightOffset];
	
	[self setTitle:NSLocalizedString(@"personal.profile.controller.title", nil)];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
	[self reconfigureActionButton:@"GreenButton"];
}

- (void)initControllers
{
	self.personalProfile = [[PersonalProfileViewController alloc] init];
	self.personalProfile.objectModel = self.objectModel;
	
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

- (void)setHeightOffsets:(CGFloat)heightOffset
{
	//more lovely arbitrary constants.
	self.personalProfile.heightOffset = heightOffset + 20;
	self.businessProfile.heightOffset = heightOffset + 20;
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
@end
