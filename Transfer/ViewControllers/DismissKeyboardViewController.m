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
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	[self.view addGestureRecognizer:recognizer];
}

- (void)dismissKeyboard
{
    [UIApplication dismissKeyboard];
}

@end
