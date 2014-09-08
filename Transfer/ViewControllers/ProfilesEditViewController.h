//
//  ProfilesEditViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"
#import "ObjectModel.h"
#import "TransparentModalViewController.h"

@interface ProfilesEditViewController : TabbedHeaderViewController<TransparentModalViewControllerDelegate>

@property (nonatomic, strong) ObjectModel* objectModel;

@end
