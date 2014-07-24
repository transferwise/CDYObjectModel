//
//  PaymentProfileViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"
#import "ObjectModel.h"

@interface PaymentProfileViewController : TabbedHeaderViewController

@property (nonatomic) BOOL allowProfileSwitch;
@property (nonatomic, strong) ObjectModel* objectModel;
@property (nonatomic, strong) NSString* buttonTitle;
@property (nonatomic, strong) id profileValidation;

@end
