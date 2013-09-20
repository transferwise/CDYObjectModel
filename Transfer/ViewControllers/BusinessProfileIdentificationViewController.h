//
//  BusinessProfileIdentificationViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalProfileIdentificationViewController.h"

@class ObjectModel;

@interface BusinessProfileIdentificationViewController : UITableViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, copy) IdentificationCompleteBlock completionHandler;

@end
