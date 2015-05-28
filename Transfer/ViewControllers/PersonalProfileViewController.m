//
//  PersonalProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "PersonalProfileSource.h"
#import "GoogleAnalytics.h"

@interface PersonalProfileViewController ()

@end

@implementation PersonalProfileViewController

- (id)init
{
    self = [super initWithSource:[[PersonalProfileSource alloc] init]];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (id)initWithActionButtonTitle:(NSString *)title
					 isExisting:(BOOL)isExisting
	doNotShowMessageForExisting:(BOOL)doNotShowMessageForExisting
{
	self = [super initWithSource:[[PersonalProfileSource alloc] init]
					 buttonTitle:title];
	if (self)
	{
		self.isExisting = isExisting;
		self.doNotShowSuccessMessageForExisting = doNotShowMessageForExisting;
	}
	return self;
}

@end
