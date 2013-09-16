//
//  TransferBackButtonItem.m
//  Transfer
//
//  Created by Jaanus Siim on 9/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferBackButtonItem.h"
#import "Constants.h"

@interface TransferBackButtonItem ()

@property (nonatomic, copy) JCSActionBlock tapHandler;

@end

@implementation TransferBackButtonItem

+ (TransferBackButtonItem *)backButtonWithTapHandler:(JCSActionBlock)tapHandler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	if (IOS_7) {
		[button setImage:[UIImage imageNamed:@"BackButtonArrow7"] forState:UIControlStateNormal];
	} else {
		[button setImage:[UIImage imageNamed:@"BackButtonArrow.png"] forState:UIControlStateNormal];
	}
    [button sizeToFit];
    TransferBackButtonItem *result = [[TransferBackButtonItem alloc] initWithCustomView:button];
    [button addTarget:result action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    [result setTapHandler:tapHandler];
    return result;
}

- (void)tapped {
    self.tapHandler();
}

@end
