//
//  PersonalPaymentProfileViewController.m
//  Transfer
//
//  Created by Juhan Hion on 04.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "BusinessPaymentProfileViewController.h"
#import "BusinessProfileViewController.h"
#import "TransferBackButtonItem.h"

@interface BusinessPaymentProfileViewController ()

@property (nonatomic, strong) BusinessProfileViewController* businessProfile;

@end

@implementation BusinessPaymentProfileViewController

- (void)viewDidLoad
{
	self.showFullWidth = YES;
	self.showButtonForIpad = YES;
	
	self.businessProfile = [[BusinessProfileViewController alloc] init];
	self.businessProfile.objectModel = self.objectModel;
	
	if(self.profileValidation)
	{
		self.businessProfile.profileValidation = self.profileValidation;
	}
	
	[super configureWithControllers:@[self.businessProfile]
							 titles:@[NSLocalizedString(@"profile.selection.text.personal.profile", nil)]
						actionTitle:self.buttonTitle ? self.buttonTitle :  NSLocalizedString(@"confirm.payment.footer.button.title", nil)
						actionStyle:@"greenButton"
					   actionShadow:@"greenShadow"					
					 actionProgress:0.3f];
    [super viewDidLoad];
	
	[self setTitle:NSLocalizedString(@"personal.profile.controller.title", nil)];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
}

- (void)actionTappedWithController:(UIViewController *)controller atIndex:(NSUInteger)index
{
	if (controller == self.businessProfile)
	{
		[self.businessProfile validateProfile];
	}
}

@end
