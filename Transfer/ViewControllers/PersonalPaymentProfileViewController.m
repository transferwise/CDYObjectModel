//
//  PersonalPaymentProfileViewController.m
//  Transfer
//
//  Created by Juhan Hion on 04.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PersonalPaymentProfileViewController.h"
#import "PersonalProfileViewController.h"
#import "TransferBackButtonItem.h"

@interface PersonalPaymentProfileViewController ()<ProfileEditViewControllerDelegate>

@property (nonatomic, strong) PersonalProfileViewController* personalProfile;
@property (nonatomic, strong) TRWActionBlock alternateAction;

@end

@implementation PersonalPaymentProfileViewController

- (void)viewDidLoad
{
	self.showFullWidth = YES;
	
	self.personalProfile = [[PersonalProfileViewController alloc] init];
	self.personalProfile.objectModel = self.objectModel;
	self.personalProfile.allowProfileSwitch = self.allowProfileSwitch;
	self.personalProfile.delegate = self;
	
	if(self.profileValidation)
	{
		self.personalProfile.profileValidation = self.profileValidation;
	}
	
	[super configureWithControllers:@[self.personalProfile]
							 titles:@[NSLocalizedString(@"profile.selection.text.personal.profile", nil)]
						actionTitle:self.buttonTitle ? self.buttonTitle :  NSLocalizedString(@"confirm.payment.footer.button.title", nil)
						actionStyle:@"greenButton"
					 actionProgress:0.3f];
    [super viewDidLoad];
	
	[self setTitle:NSLocalizedString(@"personal.profile.controller.title", nil)];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
}

- (void)actionTappedWithController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if (controller == self.personalProfile)
	{
		if (self.alternateAction)
		{
			self.alternateAction();
		}
		else
		{
			[self.personalProfile validateProfile];
		}
	}
}

- (void)changeActionButtonTitle:(NSString *)title andAction:(TRWActionBlock)action
{
	[self resetActionButtonTitle:title];
	self.alternateAction = action;
}

@end
