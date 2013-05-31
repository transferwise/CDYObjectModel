//
//  PersonalProfileViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"
#import "Constants.h"

@class ProfileDetails;
@protocol PersonalProfileValidation;

@interface PersonalProfileViewController : DataEntryViewController

@property (nonatomic, copy) TRWActionBlock afterSaveAction;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong, readonly) ProfileDetails *userDetails;
@property (nonatomic, strong) id<PersonalProfileValidation> profileValidation;

@end
