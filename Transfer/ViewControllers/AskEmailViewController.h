//
//  AskEmailViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 09/05/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DismissKeyboardViewController.h"

typedef void (^AskEmailReturnBlock)(NSString *email);

@class ObjectModel;

//action block to get the name

@interface AskEmailViewController: DismissKeyboardViewController<UITextFieldDelegate>

- (id)init __attribute__((unavailable("init unavailable, use initWithReturnBlock:")));
- (instancetype)initWithReturnBlock:(AskEmailReturnBlock)returnBlock;

@end
