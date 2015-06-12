//
//  OptionalSplitViewController.m
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "OptionalSplitViewController.h"

@interface OptionalSplitViewController ()

@property (nonatomic,strong)UIViewController* presentedDetailController;

@end

@implementation OptionalSplitViewController

-(void)presentDetail:(UIViewController*)controller
{
    if(!self.detailContainer)
    {
        if(controller)
        {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else
    {
		self.presentedDetailController.view.opaque = NO;
		self.presentedDetailController.view.alpha = 1.f;
		
		if (controller)
		{
			controller.view.opaque = NO;
			controller.view.alpha = 0.f;
			controller.view.frame = self.detailContainer.bounds;
			controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		}
		
        UIViewController* fadeOut = self.presentedDetailController;
        UIViewController* fadeIn = controller;
        
		[UIView animateWithDuration:0.3f
						 animations:^{
							 fadeOut.view.alpha = 0.f;
							 
							 if (controller)
							 {
                                 [fadeIn willMoveToParentViewController:self];
								 [self addChildViewController:fadeIn];
                                 [fadeIn didMoveToParentViewController:self];
								 [self.detailContainer addSubview:fadeIn.view];
								 fadeIn.view.alpha = 1.f;
							 }
						 }
						 completion:^(BOOL finished){
                             [fadeOut.view removeFromSuperview];
                             [fadeOut removeFromParentViewController];
							 fadeIn.view.opaque = YES;
						 }];
		
		self.presentedDetailController = controller;
    }
}

-(UIViewController*)currentDetailController
{
    return self.presentedDetailController;
}

@end
