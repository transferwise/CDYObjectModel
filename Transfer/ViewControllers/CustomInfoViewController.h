//
//  CustomInfoViewController.h
//  Transfer
//
//  Created by Mats Trovik on 09/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"

@interface CustomInfoViewController : TransparentModalViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, copy) NSString *dismissButtonTitle;
@property (nonatomic, strong) UIImage *infoImage;

@end
