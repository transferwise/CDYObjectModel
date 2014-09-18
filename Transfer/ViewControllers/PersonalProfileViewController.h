//
//  PersonalProfileViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ProfileEditViewController.h"

@interface PersonalProfileViewController : ProfileEditViewController

- (id)initWithActionButtonTitle:(NSString *)title
					 isExisting:(BOOL)isExisting;

@end
