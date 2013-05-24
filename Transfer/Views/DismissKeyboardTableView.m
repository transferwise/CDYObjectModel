//
//  DismissKeyboardTableView.m
//  Transfer
//
//  Created by Jaanus Siim on 5/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DismissKeyboardTableView.h"
#import "UIApplication+Keyboard.h"

@implementation DismissKeyboardTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTapGestureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self createTapGestureRecognizer];
    }

    return self;
}

- (void)createTapGestureRecognizer {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [recognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:recognizer];
}

- (void)tapped {
    [UIApplication dismissKeyboard];
}

@end
