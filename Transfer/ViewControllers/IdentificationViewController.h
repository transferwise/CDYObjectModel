//
//  IdentificationViewController.h
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"
#import "Constants.h"

@interface IdentificationViewController : DataEntryViewController

@property (nonatomic, copy) TRWActionBlock afterSaveBlock;

@end
