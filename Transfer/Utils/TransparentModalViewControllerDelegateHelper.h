//
//  TransparentModalViewControllerDelegateHelper.h
//  Transfer
//
//  Created by Juhan Hion on 26.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentModalViewController.h"
#import "Constants.h"

@interface TransparentModalViewControllerDelegateHelper : NSObject<TransparentModalViewControllerDelegate>

- (instancetype)initWithCompletion:(TRWActionBlock)completion;

@end
