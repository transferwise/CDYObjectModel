//
//  TransferBackButtonItem.m
//  Transfer
//
//  Created by Jaanus Siim on 9/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferBackButtonItem.h"
#import "Constants.h"

@interface TransferBackButtonItem ()<UINavigationControllerDelegate>

@property (nonatomic, copy) TRWActionBlock tapHandler;
@property (nonatomic, assign) UINavigationController *navigationController;

@end

@implementation TransferBackButtonItem

+ (TransferBackButtonItem *)backButtonWithTapHandler:(TRWActionBlock)tapHandler
{
    return [TransferBackButtonItem backButtonForPoppedNavigationController:nil
																tapHandler:tapHandler
																	isBlue:YES];
}

+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController
{
    return [self backButtonForPoppedNavigationController:navigationController isBlue:YES];
}

+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController
															 isBlue:(BOOL)isBlue
{
	return [TransferBackButtonItem backButtonForPoppedNavigationController:navigationController tapHandler:nil isBlue:isBlue];
}

+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController
														 tapHandler:(TRWActionBlock)tapHandler
															 isBlue:(BOOL)isBlue
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:isBlue ? @"BackButtonArrowBlue" : @"BackButtonArrow"] forState:UIControlStateNormal];
    CGRect newFrame = button.frame;
    newFrame.size = CGSizeMake(44, 44);
    if(!IPAD)
    {
        button.contentEdgeInsets = UIEdgeInsetsMake(0,-16,0,16);
    }
    
    button.frame=newFrame;
    TransferBackButtonItem *result = [[TransferBackButtonItem alloc] initWithCustomView:button];
    [button addTarget:result action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    [result setTapHandler:tapHandler];
    [result setNavigationController:navigationController];
    return result;
}

- (void)tapped {
    if(self.navigationController)
    {
        if (self.navigationController.topViewController.navigationItem.leftBarButtonItem == self) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }

    if(self.tapHandler)
    {
        self.tapHandler();
    }
}

@end
