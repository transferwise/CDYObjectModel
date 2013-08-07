//
//  OpenIDViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;

@interface OpenIDViewController : UIViewController

@property (nonatomic, copy) NSString *provider;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *providerName;
@property (nonatomic, assign) BOOL registerUser;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
