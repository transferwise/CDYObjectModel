//
//  TransferBackButtonItem.h
//  Transfer
//
//  Created by Jaanus Siim on 9/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface TransferBackButtonItem : UIBarButtonItem

+ (TransferBackButtonItem *)backButtonWithTapHandler:(TRWActionBlock)tapHandler;
+ (TransferBackButtonItem *)backButtonForPoppedNavigationController:(UINavigationController *)navigationController;

@end
