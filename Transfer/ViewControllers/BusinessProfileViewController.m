//
//  BusinessProfileViewController.m
//  Transfer
//
//  Created by Henri Mägi on 29.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "BusinessProfileViewController.h"
#import "BusinessProfileSource.h"
#import "GoogleAnalytics.h"

@interface BusinessProfileViewController ()

@end

@implementation BusinessProfileViewController

- (id)init
{
    self = [super initWithSource:[[BusinessProfileSource alloc] init]];
    if (self)
	{
		self.reloadBaseData = YES;
    }
    return self;
}

- (id)initWithActionButtonTitle:(NSString *)title
{
	self = [super initWithSource:[[BusinessProfileSource alloc] init] buttonTitle:title];
	if (self)
	{
		self.reloadBaseData = YES;
	}
	return self;
}

@end
