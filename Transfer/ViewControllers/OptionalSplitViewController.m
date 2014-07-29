//
//  OptionalSplitViewController.m
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "OptionalSplitViewController.h"

@interface OptionalSplitViewController ()

@property (nonatomic,weak)UIViewController* presentedDetailController;

@end

@implementation OptionalSplitViewController

-(void)presentDetail:(UIViewController*)controller
{
    if(!self.detailContainer)
    {
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [self.presentedDetailController.view removeFromSuperview];
        [self.presentedDetailController removeFromParentViewController];
        if(controller)
        {
            [self addChildViewController:controller];
            [self.detailContainer addSubview:controller.view];
            controller.view.frame = self.detailContainer.bounds;
            controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        self.presentedDetailController=controller;
    }
}

-(UIViewController*)currentDetailController
{
    return self.presentedDetailController;
}

@end
