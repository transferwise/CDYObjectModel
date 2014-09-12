//
//  TouchIdPromptViewController.h
//  Transfer
//
//  Created by Mats Trovik on 08/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"
@class TouchIdPromptViewController;

@interface TouchIdPromptViewController : TransparentModalViewController

-(void)presentOnViewController:(UIViewController *)hostViewcontroller withUsername:(NSString*)username password:(NSString*)password;

@end
