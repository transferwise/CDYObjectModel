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

/**
 *  Invokes the actionButtonBlock.
 */
-(IBAction)actionButtonTapped;

/**
 *  convenince method for getting an instance with a green tick and mapCloseToAction set to YES.
 *
 *  @param messageKey message. An attempt will be made to get the localised version.
 *
 *  @return green tick screen with your message
 */
+(instancetype)successScreenWithMessage:(NSString*)messageKey;
@end
