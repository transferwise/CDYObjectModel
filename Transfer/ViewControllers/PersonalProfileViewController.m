//
//  PersonalProfileViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileViewController.h"
#import "PersonalProfileSource.h"
#import "QuickProfileValidationOperation.h"
#import "GoogleAnalytics.h"

@interface PersonalProfileViewController ()

@end

@implementation PersonalProfileViewController

- (id)init
{
    self = [super initWithSource:[[PersonalProfileSource alloc] init] quickValidation:[QuickProfileValidationOperation personalProfileValidation]];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (id)initWithActionButtonTitle:(NSString *)title
{
	self = [super initWithSource:[[PersonalProfileSource alloc] init] quickValidation:[QuickProfileValidationOperation personalProfileValidation] buttonTitle:title];	
	if (self)
	{
		// Custom init
	}
	return self;
}

@end
