//
//  PersonalPaymentProfileViewController.h
//  Transfer
//
//  Created by Juhan Hion on 04.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"

@class ObjectModel;

@interface PersonalPaymentProfileViewController : TabbedHeaderViewController

@property (nonatomic) BOOL allowProfileSwitch;
@property (nonatomic, strong) ObjectModel* objectModel;
@property (nonatomic, strong) NSString* buttonTitle;
@property (nonatomic, strong) id profileValidation;
//used for filling missing US fields
@property (nonatomic) BOOL isExisting;

@end
