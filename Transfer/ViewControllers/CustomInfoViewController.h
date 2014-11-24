//
//  CustomInfoViewController.h
//  Transfer
//
//  Created by Mats Trovik on 09/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"

@interface CustomInfoViewController : TransparentModalViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, copy) NSString *actionButtonTitle;
@property (nonatomic, strong) UIImage *infoImage;

/**
 *  Set to override the behaviour when the action button is tapped. Default behaviour is call to dismiss.
 */
@property (nonatomic,copy) void(^actionButtonBlock)(void);

/**
 *  set to YES to make the close button invoke the actionButtonBlock rather than just dismiss.
 */
@property (nonatomic,assign) BOOL mapCloseButtonToAction;

//Invokes the actionButtonBlock.
-(IBAction)actionButtonTapped;
@end
