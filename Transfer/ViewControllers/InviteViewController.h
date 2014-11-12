//
//  InviteViewController.h
//  Transfer
//
//  Created by Mats Trovik on 14/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"
@class ObjectModel;

@interface InviteViewController : TransparentModalViewController

@property (nonatomic, strong) ObjectModel* objectModel;
@property (nonatomic, strong) NSArray* referralLinks;

@end
