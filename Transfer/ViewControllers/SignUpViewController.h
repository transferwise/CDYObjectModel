//
//  SignUpViewController.h
//  Transfer
//
//  Created by Henri Mägi on 24.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"

@class ObjectModel;

@interface SignUpViewController : DataEntryViewController

@property (nonatomic) ObjectModel *objectModel;

@end
