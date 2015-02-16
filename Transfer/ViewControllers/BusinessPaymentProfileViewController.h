//
//  BusinessPaymentProfileViewController.h
//  Transfer
//
//  Created by Juhan Hion on 04.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"
#import "BusinessProfileValidation.h"

@class ObjectModel;

@interface BusinessPaymentProfileViewController : TabbedHeaderViewController

@property (nonatomic) BOOL allowProfileSwitch;
@property (nonatomic, strong) ObjectModel* objectModel;
@property (nonatomic, strong) NSString* buttonTitle;
@property (nonatomic, strong) id<BusinessProfileValidation> profileValidation;

@end
