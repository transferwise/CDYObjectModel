//
//  ContactsViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancelableCellViewController.h"

@class ObjectModel;

@interface ContactsViewController : CancelableCellViewController

@property (nonatomic, strong) ObjectModel *objectModel;

@end
