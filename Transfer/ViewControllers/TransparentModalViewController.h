//
//  TransparentModalViewController.h
//  Transfer
//
//  Created by Mats Trovik on 12/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransparentModalViewController : UIViewController

-(void)presentOnViewController:(UIViewController*)hostViewcontroller;
-(IBAction)dismiss;

@end
