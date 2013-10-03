//
//  ClaimAccountViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class ObjectModel;

@interface ClaimAccountViewController : DataEntryViewController

@property (nonatomic, strong) ObjectModel *objectModel;

@end
