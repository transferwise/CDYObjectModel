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

+ (TransferBackButtonItem *)backButtonWithTapHandler:(TRWActionBlock)tapHandler {
    return [TransferBackButtonItem backButtonForPoppedNavigationController:nil tapHandler:tapHandler];
}

+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController {
    return [TransferBackButtonItem backButtonForPoppedNavigationController:navigationController tapHandler:nil];
}

+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController tapHandler:(TRWActionBlock)tapHandler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IOS_7) {
        [button setImage:[UIImage imageNamed:@"BackButtonArrow7"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"BackButtonArrow.png"] forState:UIControlStateNormal];
    }
    [button sizeToFit];
    TransferBackButtonItem *result = [[TransferBackButtonItem alloc] initWithCustomView:button];
    [button addTarget:result action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    [result setTapHandler:tapHandler];
    [result setNavigationController:navigationController];
    return result;
}

- (void)tapped {
    
    if (self.navigationController.topViewController.navigationItem.leftBarButtonItem == self) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    if(self.tapHandler)
    {
        self.tapHandler();
    }
}

@end
