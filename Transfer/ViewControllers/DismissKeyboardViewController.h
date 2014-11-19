//
//  DismissKeyboardViewController.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;

@interface DismissKeyboardViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorHeights;

@end
