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

@interface PaymentProfileViewController ()

@property (nonatomic, strong) PersonalProfileViewController* personalProfile;
@property (nonatomic, strong) ProfileEditViewController* businessProfile;

@end

@implementation PaymentProfileViewController

- (void)viewDidLoad {
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

@end
