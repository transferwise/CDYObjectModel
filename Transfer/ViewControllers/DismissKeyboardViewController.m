//
//  DismissKeyboardViewController.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DismissKeyboardViewController.h"
#import "UIApplication+Keyboard.h"

@interface DismissKeyboardViewController ()

@property (nonatomic, strong) UIGestureRecognizer *recognizer;

@end

@implementation DismissKeyboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	self.recognizer.delegate = self;
	[self.view addGestureRecognizer:self.recognizer];
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

- (void)dismissKeyboard
{
    [UIApplication dismissKeyboard];
}

@end
