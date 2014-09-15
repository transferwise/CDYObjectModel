//
//  DismissKeyboardTableView.m
//  Transfer
//
//  Created by Jaanus Siim on 5/24/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DismissKeyboardTableView.h"
#import "UIApplication+Keyboard.h"

@interface DismissKeyboardTableView ()

@property (strong, nonatomic) UITapGestureRecognizer *recognizer;

@end

@implementation DismissKeyboardTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        [self createTapGestureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
        [self createTapGestureRecognizer];
    }

    return self;
}

- (void)createTapGestureRecognizer
{
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.recognizer setNumberOfTapsRequired:1];
    [self.recognizer setNumberOfTouchesRequired:1];
    [self.recognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:self.recognizer];
}

- (void)tapped:(UITapGestureRecognizer *)sender
{
    [UIApplication dismissKeyboard];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([gestureRecognizer isEqual:self.recognizer])
	{
		// for ios 7 , need to compare with UITableViewCellContentView
		if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [touch.view.superview isKindOfClass:[UITableViewCell class]])
		{
			return FALSE;
		}
	}
	return TRUE;
}

@end
