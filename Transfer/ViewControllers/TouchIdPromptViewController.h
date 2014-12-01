//
//  TouchIdPromptViewController.h
//  Transfer
//
//  Created by Mats Trovik on 08/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"


@class TouchIdPromptViewController;

@protocol TouchIdPromptViewControllerDelegate <NSObject>

@required
-(void)touchIdPromptIsFinished:(TouchIdPromptViewController*)controller;

@end

/**
 *  displays a prompt to associate login details with touch ID.
 *
 */
@interface TouchIdPromptViewController : TransparentModalViewController

@property (nonatomic, weak) id<TouchIdPromptViewControllerDelegate>touchIdDelegate;

-(void)presentOnViewController:(UIViewController *)hostViewcontroller withUsername:(NSString*)username password:(NSString*)password;

@end
